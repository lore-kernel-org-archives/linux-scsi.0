From: G S <gogman69-linuxscsi@yahoo.com>
Subject: Re: Why does SCSI mid layer mark the LUN offline in this situation?
Date: Thu, 1 Oct 2009 12:08:56 -0600
Message-ID: <da0ca6030910011108p38312559tf06c7dc80d4d031f@mail.gmail.com>
References: <da0ca6030909302246s4527cc98v6e3b37d7ca3bba2d@mail.gmail.com>
	 <4AC44CB6.1050304@cisco.com> <4AC4B642.5050000@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:49492 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbZJASIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 14:08:53 -0400
Received: by yxe37 with SMTP id 37so367725yxe.33
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2009 11:08:57 -0700 (PDT)
In-Reply-To: <4AC4B642.5050000@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@emulex.com>
Cc: Joe Eykholt <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Joe, James, thanks for the replies.

Bit more follow up.

I understand about the target-level change is detected by the
transport.  And the transport kicks off the scans.  And the LUN level
change is not detected by the transport.

So, my follow up comments and questions are,

a) When the disk array comes back up from restart with LUN 1 deleted,
that rebooting will cause RSCN at the transport layer.

b) HBA driver kicks off the scans, and this is scans of FC ports and
not a scan for LUN-level changes, right?

c) Is this behavior i noted in (b) at the HBA driver different between
the "standard" versus "inbox" (aka. upstream) HBA drivers?

d) Does the HBA driver notify the SCSI mid layer to kick off LUN-level
scan, to look for LUN-level changes?

e) If the HBA driver does not notify the SCSI mid layer of transport
level change (from RSCN), then will SCSI mid layer continue to think
that LUN 1, and kernel structures for LUN 1 will still be intact in
the SCSI mid layer?

f) If SCSI mid layer still has LUN 1 marked online, then should the
application (using "sg" dsf) be able to access LUN 1 once the LUN 1 is
recreated on the disk array, without having to cause manual scan
through /proc ?

Thanks much,

G

On Thu, Oct 1, 2009 at 8:01 AM, James Smart <James.Smart@emulex.com> wr=
ote:
>
> Joe's description is correct.=A0=A0 Target-level change is detected b=
y the transport, and the transport kicks off the scans.=A0 Lun-level ch=
ange is not detected by the transport, thus its up to the midlayer or a=
dmin to rescan. Currently, the midlayer doesn't understand the "luns ch=
anged" sense codes and does not rescan.=A0 Thus you must use the steps =
indicated to scan=A0 (please avoid anything in /proc as, as much as it =
continues to exist, it is being deprecated).
>
> -- james s
>
>
> Joe Eykholt wrote:
>
> G S wrote:
>
>
> Howdy,
>
> I have a Linux (2.6) using Emulex and QLogic FC HBA's to a disk array
> product, with a single LUN presented, say LUN 1.
>
> The dsf is created for LUN 1 and i can send SCSI commands to LUN 1.
> And i'm using "sg".
>
> If i delete LUN 1 from disk array.  Reboot the disk array.  Array
> boots up only with LUN 0.
>
> I have recreated LUN 1 on the target storage array.
>
> But any attempt to send SCSI command to LUN 1 fails because LUN 1 has
> been marked offline by SCSI mid layer.
>
> Why?  Is it because RSCN seen by HBA driver is passed up to SCSI mid
> layer to trigger re-scan?  And re-scan no longer finds LUN 1, so LUN =
1
> kernel structures are torned down, and LUN 1 marked offline by SCSI
> mid layer?
>
>
> If I understand your sequence correctly, rebooting the disk array
> would cause a RSCN to the HBA, and that would cause it to delete LUN =
0 and 1.
> When the disk array comes up and logs into the fabric again, another
> RSCN goes to the HBA and it sees the target (array) and presents
> it to the transport layer and SCSI.  It scans LUN0 (does REPORT LUNS)
> and it reports no other LUNs.  No LUN 1 at this point.
>
> Then you add LUN 1 on the array.  There's no event caused by that
> as far as I know.   I'm not a complete expert on this and it
> depends on your array, I think.  It may cause an check condition
> on the next I/O that goes to LUN0, but that may never happen.
> So nothing happens on the server.   It doesn't cause an RSCN because
> the array didn't re-login to the fabric (that would be disruptive
> for other initiators).
>
>
>
> Doing following to add back LUN 1 will bring it back for access,
>
> # echo "scsi add-single-device <H> <B> <T> <L>" > /proc/scsi/scsi
>
> Above "echo" seems to cause a blind re-scan by sending SCSI INQUIRY t=
o
> LUN 1 on the h/b/t/l hardware path.  That SCSI INQUIRY succeeds.  And
> that success seems to cause LUN 1 to be marked online again.
>
>
> OK.  I think you can also echo 1 to /sys/class/scsi_host/hostX/
> scan
>
> I hope that helps and someone will correct me if any of this is wrong=
=2E
>
> 	Joe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
