From: Sumit Agarwal <aksumit@india.hp.com>
Subject: Re: Executing a scsi command
Date: Fri, 08 Nov 2002 11:49:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCBF92F.776EDD64@india.hp.com>
References: <3DCA6E46.91894890@patni.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------760BD982BC04487BC66CF328"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------760BD982BC04487BC66CF328
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

The best way to go about is to use the ioctl calls. In
addition during
   the Initialization or Inquiry you can use IOCTL calls to
associate
   the devices with your driver and then later on use them
at your
   discretion using scsi_do_cmd etc.

If you dont want to do this then an ugly way is as follows

Most of the block devices have their arrays that can be used
for this
purpose as static. you have to employ different methods
based on major
number to tackle this. However, it is better if you try not
to do this.
for e.g
for disks you need to hack sd.c to retrieve the value from
rscsi_disks.

for generic driver you can have your own inode and file
pointer created
the invoke sg_open() and get sfp pointer from filp->private
and then
use sfp->device for your purpose and so on.

Does anyone else have a better alternative?

Thanks,
Sumit






MShetty wrote:
> 
> Hi,
> 
> I want to execute a scsi cmd from my driver. The API's that I found
> (scsi_do_cmd, scsi_wait_req) require a pointer to the scsi_device or
> scsi_host structure.. Any idea how I could get them.... given the major
> and minor no. of the device to which the command is to be sent.
> 
> Is there an alternative way of executing a scsi_cmd ??
> 
> Would help if I could get some help on the above.
> 
> Thanks and Regards,
> M Shetty
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--------------760BD982BC04487BC66CF328
Content-Type: text/x-vcard; charset=us-ascii;
 name="aksumit.vcf"
Content-Transfer-Encoding: 7bit
Content-Description: Card for Sumit Agarwal
Content-Disposition: attachment;
 filename="aksumit.vcf"

begin:vcard 
n:Agarwal;Sumit
tel;fax:(91)(80)2200196
tel;home:+919845205210
tel;work:2051126
x-mozilla-html:FALSE
url:www.hp.com
org:HP-ISO;HPUX
version:2.1
email;internet:aksumit@india.hp.com
title:Senior Software Engineer
adr;quoted-printable:;;Hewlett-Packard,=0D=0AIndia Software Operation Pvt. Ltd.,=0D=0A29, Cunningham Road,=0D=0A;Bangalore;Karnataka;560052;India
fn:Sumit Agarwal
end:vcard

--------------760BD982BC04487BC66CF328--

