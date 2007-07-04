From: rjshi@fudan.edu.cn
Subject: mmap-ed IO between application in user mode and SCSI driver fails
 after lk 2.6.15
Date: Wed, 04 Jul 2007 20:21:15 +0800
Message-ID: <c6fbfb7c6fe51e.c6fe51ec6fbfb7@fudan.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [61.129.42.10] ([61.129.42.10]:33627 "EHLO mail.fudan.edu.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758322AbXGDNgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jul 2007 09:36:33 -0400
Received: from fudan.edu.cn (localhost [127.0.0.1])
 by mail.fudan.edu.cn (iPlanet Messaging Server 5.2 HotFix 2.06 (built Mar 28
 2005)) with ESMTP id <0JKN00L47MBFL3@mail.fudan.edu.cn> for
 linux-scsi@vger.kernel.org; Wed, 04 Jul 2007 20:21:15 +0800 (CST)
Content-language: zh-CN
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Issue:  mmap-ed IO between application in user mode and SCSI driver 
fails after lk 2.6.15
 
We used mmap-ed IO to implement the communication between application 
in user mode and SCSI driver. It works well in lk 2.6.11 and its early 
versions, but  it fails in lk 2.6.15.
In lk 2.6.15, we found the pointer to the reserved buffer (databuffer 
pointer in SRB) from the driver side is not aligned to PAGE_SIZE(4K)
(in lk 2.6.11 or earlier, it's correct and can get the reserved buffer 
data), so we think after the memory map of  the kernel, the pointer to 
the reserved buffer from the driver side has wrongly pointed to an 
invalid place in memory. As this program works well in lk  2.6.11 and 
its early versions, we gues
s it is a kernel bug introduced after lk 2.6.11. Could anyone give us 
more hints.Thanks a lot!
 
The program fragment from the application in user mode is as follows:
 
typedef struct _MGMT_CONTROL
{
    SRB_IO_CONTROL SrbIoCtrl;
    U8_t           InBuf  [ 16384 ];   // Fixed at 16KB
    U8_t           OutBuf [ 16384 ];   // Fixed at 16KB
    U8_t           pad       [ 2 ]; 
} PACKED MGMT_CONTROL;
 
do_exchange_with_driver( char *inBuf, char *outBuf )
{  
    int  sg_fd;// My descriptor
    ...
    unsigned size     = sizeof( MGMT_CONTROL );
    unsigned pageSize = getpagesize( ); // usually 4K
 
    //
    // Round up our request size such that is equals an even
    // number of OS memory pages
    //
    size = ( ( size / pageSize ) + 1 ) * pageSize;
 
    //
    // Tell the 'sg' driver that we would like him to use a buffer
    // of 'size' bytes as calculated above
    //
    retVal = ioctl( sg_fd, SG_SET_RESERVED_SIZE, &size );
 
    void *b = mmap( 0,                      // Start (0 recommended)
       (size_t) size,           // Mapped buffer size
       PROT_READ | PROT_WRITE, // Protocol
       MAP_SHARED,             // Access mode
       sg_fd,                     // Our descriptor
       0 );                    // Offset (0 recommended)
 
    if( b == MAP_FAILED )
    {
       debugPrintf( "mmap() call failed, errno = %d\n", errno );
       continue;
    }
 
 
    ...
 
       bool        status;
 
 
    U8_t        cdb[10]          __attribute__ ((aligned (16)));
    U8_t        sense_buffer[32] __attribute__ ((aligned (16)));
    sg_io_hdr_t io_hdr           __attribute__ ((aligned (16)));
    int xstatus;
 
    MGMT_CONTROL *buffer;
    SRB_IO_CONTROL   *SrbIoCtrl;
 
    bzero( cdb         , sizeof( cdb          ) );
    bzero( sense_buffer, sizeof( sense_buffer ) );
    bzero( &io_hdr     , sizeof( io_hdr       ) );
 
    buffer =  (MGMT_CONTROL *) b;
    bzero( buffer, sizeof( *buffer ) );
 
    strcpy( (char *) buffer->InBuf, inBuf );
 
    cdb[0] = 0xff; //my scsi command
 
    SrbIoCtrl               = (SRB_IO_CONTROL *) &buffer->SrbIoCtrl;
    SrbIoCtrl->HeaderLength = sizeof( SRB_IO_CONTROL );
    strncpy( (char *) SrbIoCtrl->Signature, (const char *) "CMD_RIO ", 
8 );
    SrbIoCtrl->Timeout      = 5; // Seconds
 
    SrbIoCtrl->ReturnCode   = 0xffffffff;
    SrbIoCtrl->Length       = sizeof( *buffer ) - sizeof( 
SRB_IO_CONTROL );
    SrbIoCtrl->Length       = 16384; // PAS CHANGE
 
    io_hdr.interface_id    = 'S';
    io_hdr.cmd_len         = 10;
    io_hdr.iovec_count     = 0;
    io_hdr.mx_sb_len       = sizeof( sense_buffer );
    io_hdr.dxfer_direction = SG_DXFER_TO_FROM_DEV;
    io_hdr.dxfer_len       = 16384;
 
    io_hdr.cmdp            = cdb;
    io_hdr.sbp             = sense_buffer;
    io_hdr.timeout         = 20000; // 20000 millisecs == 20 seconds
    io_hdr.flags           = SG_FLAG_MMAP_IO;
    io_hdr.pack_id         = 0;     // Default
    io_hdr.usr_ptr         = NULL;  // Default
 
    msync( buffer, sizeof( *buffer ), MS_SYNC );
 
    xstatus = ioctl( sg_fd, SG_IO, &io_hdr );
}
 

