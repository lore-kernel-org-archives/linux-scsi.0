From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SYNCHRONIZE CACHE command from sd on close
Date: Mon, 15 Feb 2010 14:51:22 +0100
Message-ID: <4B79515A.6020507@interlog.com>
References: <4B79460A.7040207@interlog.com> <20100215132502.GA15360@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46382 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0BONvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2010 08:51:24 -0500
In-Reply-To: <20100215132502.GA15360@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Mon, Feb 15, 2010 at 02:03:06PM +0100, Douglas Gilbert wrote:
>> Recently, judging from error reports reaching me
>> from smartmontools, sdparm and sg_start, something
>> changed in the sd driver associated with the
>> SYNCHRONIZE CACHE command it issues when a device
>> is closed.
>>
>> That only seems to happen when the device is opened
>> RW and it exposes a nasty difference between the
>> semantics of spinning up and down ATA disks compared
>> to SCSI disks.
> 
> The sd driver itself never sends a SYNCHRONIZE CACHE in
> response to access through the block device node, it is only
> sent for barrier requests, when hot-unplugging a scsi device,
> or when shutting down the system.
> 
> Now that has change recently is that we now send down a cache
> flush from the block layer when fsync is called on the block
> device node.  The kernel should never call that by itself when
> closing the device, but can you double check that the tools
> don't call fsync/fdatasync/msync or open the block device node
> using O_SYNC/O_DYSNC?

What about O_NONBLOCK (which stops a hang on open)?
The open code common to my utilities in Linux is
below.

Doug Gilbert


int
scsi_pt_open_device(const char * device_name, int read_only, int verbose)
{
     int oflags = O_NONBLOCK;

     oflags |= (read_only ? O_RDONLY : O_RDWR);
     return scsi_pt_open_flags(device_name, oflags, verbose);
}


int
scsi_pt_open_flags(const char * device_name, int flags, int verbose)
{
     int fd;

     if (verbose > 1) {
         if (NULL == sg_warnings_strm)
             sg_warnings_strm = stderr;
         fprintf(sg_warnings_strm, "open %s with flags=0x%x\n", device_name,
                 flags);
     }
     fd = open(device_name, flags);
     if (fd < 0)
         fd = -errno;
     return fd;
}
