From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Thu, 24 Jan 2013 15:51:39 +0100
Message-ID: <51014A7B.2060806@suse.de>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab3AXOvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2013 09:51:40 -0500
In-Reply-To: <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 01/24/2013 03:38 PM, Bart Van Assche wrote:
> On Thu, Jan 24, 2013 at 4:38 AM, Hannes Reinecke <hare@suse.de> wrote=
:
>> As for AEN, does iSCSI _do_ AEN? I thought it got removed ...
>>
>> If it does, though, it should schedule an event on its own whenever =
an AER
>> is received. The same goes for LLDDs with vendor-specific AENs; thin=
king of
>> megaraid_sas here ...
>
> Let me ask this another way. SAN users expect that the LUN list at th=
e
> initiator side gets updated automatically after a SAN configuration
> change. How should a SAN system communicate to a SCSI initiator that
> the LUN list has been changed ? Some FC SAN systems send a LIP after =
a
> configuration change to force the initiator to rescan LUNs.

And thereby disrupting traffic on _ALL_ LUNs on the loop.
Really cool idea.
I know; the one vendor which does _not_ talk to us.

> But how to inform the initiator about a LUN change for other SCSI pro=
tocols ?
 > I'm not sure that it is even possible to report such a change via=20
sense
> data in case a SAN user first removes all LUNs and after that change
> adds one or more LUNs.
>
The official way is indeed via UAs; most storage arrays (Hello,=20
NetApp!) provide a default LUN0 which is always visible.
Up to the point that some even refuse to add 'normal' disk LUNs to=20
LUN0. Or have the ominous 'Well-known Address' LUN to handle these=20
kind of issues.

Obviously, one needs to send commands to it to even _get_ an UA back.

But yeah, normally it's possible.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
