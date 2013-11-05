From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 12:04:54 -0500
Message-ID: <52792536.6020607@interlog.com>
References: <527859D9.3030607@ubuntu.com> <52791518.5070705@interlog.com> <52791B85.1090805@ubuntu.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52791B85.1090805@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 13-11-05 11:23 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/5/2013 10:56 AM, Douglas Gilbert wrote:
>> I think that you might find that almost any SCSI command
>> (translated to its ATA equivalent command) will wake up a SATA
>> disk. Perhaps just this sequence: fd = open(<ata_bloc_device>) ;
>> close(fd) ; is sufficient.
>
> No, otherwise hdparm, udisks, etc would not be able to issue the CHECK
> POWER command without waking the disk.  Most commands do wake the
> drive, but as far as I can see, nobody is sending down any, and more
> importantly, the wake is happening within the kernel pm resume path,
> not by userspace after resume.

hdparm is quite capable of using a pass-through device
to access disks. That allows it (and smartmontools) to
access physical disks in a RAID when the block layer
can only see the logical disk out front.

udisks is not that smart.


Perhaps you need to start debugging around here:

static int sd_resume(struct device *dev)
{
         struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
         int ret = 0;

         if (!sdkp->device->manage_start_stop)
                 goto done;

         sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
         ret = sd_start_stop_device(sdkp, 1);

done:
         scsi_disk_put(sdkp);
         return ret;
}

to work out if it is spun up before or after that call.

Doug Gilbert

