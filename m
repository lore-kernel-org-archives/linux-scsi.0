From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: A bug RedHat AS 4.0 kernel , is it correct, can anyone confirm
Date: Fri, 4 Mar 2005 16:49:19 -0500
Message-ID: <87f94c3705030413495704e8b2@mail.gmail.com>
References: <374639AB1012AA4C840022842AA95BC2046E46CF@ruby.patni.com>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <374639AB1012AA4C840022842AA95BC2046E46CF@ruby.patni.com>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
To: "Kotian, Deepak" <Deepak.Kotian@patni.com>
Cc: kernelnewbies@nl.linux.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I would confirm that 2.6.11 seems to have the same bug.

If so, ask on the linux-scsi (linux-scsi@vger.kernel.org) list.  The
SCSI midlayer is supported there and it is a fairly low volume list
that several SAN vendors monitor.  If the vanilla kernel has a bug
like you describe, someone will likely post a patch quickly to fix it.
 You should then be able to apply the patch to the RH kernel (voiding
your support), or hopefully RH will pickup the patch and apply it to
their kernel in a timely manner.

Also, if you are as interested in the SCSI midlayer as you appear, you
should probably join the linux-scsi list just to see what is going on
and what problems are being reported.

I been subscribed for a couple months and the most significant
activity I've seen is that several of the FC HPA vendors are moving
logic out of their drivers and into the shared code.

Greg
-- 
Greg Freemyer

On Fri, 4 Mar 2005 15:26:37 +0530, Kotian, Deepak
<Deepak.Kotian@patni.com> wrote:
> A bug RedHat AS 4.0 kernel , is it correct, can anyone confirm
> 
> Bug Description :-
> The SCSI_IOCTL_GET_IDLUN ioctl fails for LUN number > 255
> 
> Bug Details :-
> The  scsi_idlun structure is defined as follows
> typedef struct scsi_idlun {
> __u32 dev_id;
> __u32 host_unique_id;
> } Scsi_Idlun;
> 
> The dev_id is a 32 bit value and the HCLT is encoded here.
> This is derived from the following code in scsi_ioctl.c
> 
> int scsi_ioctl(struct scsi_device *sdev, int cmd, void *arg)
> {
> .....
>  case SCSI_IOCTL_GET_IDLUN:
> if (verify_area(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))
>         return -EFAULT;
> __put_user((sdev->id & 0xff)
>         + ((sdev->lun & 0xff) << 8)
>         + ((sdev->channel & 0xff) << 16)
>         + ((sdev->host->host_no & 0xff) << 24),
>         &((struct scsi_idlun *)arg)->dev_id);
>         __put_user(sdev->host->unique_id,
>                 &((struct scsi_idlun *)arg)->host_unique_id);
> .......
> }
> 
> This code clearly indicates that all the values (i.e H,C,L and T) are anded with 0xff and hence the limitation for each value (including LUN value) becomes 255.
> 
> But the scsi mid layer has the support for 512 LUNs.
> 
> So if one has to obtain the LUN number for LUNs > 255 the SCSI_IOCTL_GET_IDLUN ioctl would fail.
> 
> Thanks and Regards
> Dee[al
> 
> --
> Kernelnewbies: Help each other learn about the Linux kernel.
> Archive:       http://mail.nl.linux.org/kernelnewbies/
> FAQ:           http://kernelnewbies.org/faq/
> 
>

--
Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/
