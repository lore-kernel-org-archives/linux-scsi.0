From: Kallol Biswas <nucleodyne@comcast.net>
Subject: How to generate ILI condtion on a tape device
Date: 22 Nov 2003 00:16:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069489007.3775.15.camel@driver>
References: <200310231734.10263.krmurthy@cisco.com>
	 <20031027153932.A16679@infradead.org>
	 <03111920183201.15831@naveenb-lnx.cisco.com>
	 <20031119091717.A11499@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:28349 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262123AbTKVISC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 03:18:02 -0500
In-Reply-To: <20031119091717.A11499@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,
  I was wondering how to generate ILI condition while reading from a
tape.

A few lines from read_tape(), file st.c
.....
 if (SRpnt->sr_sense_buffer[2] & 0x20) { /* ILI */
             if (STp->block_size == 0) {
                  if (transfer < 0) {
                         if (STps->drv_block >= 0)
                             STps->drv_block+= 1;
                             return (-ENOMEM);
                  }
                  (STp->buffer)->buffer_bytes = bytes - transfer;
              } else {
                    scsi_release_request(SRpnt);
                    SRpnt = *aSRpnt = NULL;
                    if (transfer == blks) { /* We did not get anything,
error */
                       printk(KERN_NOTICE "st%d: Incorrect block
size.\n", dev);
                                                                      
                if(STps->drv_block>=0)                                                                               STps->drv_block+= blks - transfer + 1;
                                                                                st_int_ioctl(STp, MTBSR, 1);
                        return (-EIO);
                      }
 /* We have some data, deliver it */
                                               
(STp->buffer)->buffer_bytes = (blks - transfer) * STp->block_size;
                
        DEBC(printk(ST_DEB_MSG                                                        "st%d: ILI but enough data received %ld %d.\n",
               dev, count, (STp->buffer)->buffer_bytes));
         if (STps->drv_block >= 0)
                STps->drv_block += 1;
        if (st_int_ioctl(STp, MTBSR, 1))    return (-EIO);
       }

I want to make the driver print the message "ILI but enough data
received." to generate an error condition that my new driver (similar to
tape driver) encountering while running with a software from Veritas.



-- 
Kallol Biswas <nucleodyne@comcast.net>
www.nucleodyne.com

