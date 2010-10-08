From: iscsi learner <iscsilearner@gmail.com>
Subject: Re: linux-scsi on a iSCSI target mode PCIe HBA
Date: Thu, 7 Oct 2010 19:06:57 -0700
Message-ID: <AANLkTimnDSm+79FScpJ-WTsq9LeQru041d2NbsL7pA0Y@mail.gmail.com>
References: <AANLkTin0ssMxhgoYssxK3z0qYhZ0Rhjay9VPz-L9piOm@mail.gmail.com>
	<DA9003B7AE9B4262AFCD0ED717F882BE@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42218 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0JHCG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 22:06:59 -0400
Received: by fxm14 with SMTP id 14so196971fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2010 19:06:57 -0700 (PDT)
In-Reply-To: <DA9003B7AE9B4262AFCD0ED717F882BE@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 7, 2010 at 6:56 PM, Jack Wang <jack_wang@usish.com> wrote:
>
> Hi
> I have a target mode iSCSI (and linux 2.6.27) =A0 running on a PCIe H=
BA.
> =A0This target mode HBA =A0will completely offload =A0iSCSI
> from =A0storage server to =A0itself. Storage server will receive only=
 SCSI
> CDB (from this PCIe target HBA) and pass it to attached disk backend.
>
> Over the PCIe interface only the =A0SCSI =A0command-response/data is =
=A0exchanged.
>
> Experts, =A0 please clear my doubt =A0about the work/design =A0 to ma=
ke it work-
>
> I think I should =A0register myself as =A0SCSI Mid Layer LLD and =A0t=
hen all
> the =A0SCSI command/data =A0received by target-mode-iSCSI-stack will =
be
> available in =A0queuecommand interface of =A0SCSI Mid layer. =A0Is th=
at the
> right assumption and the =A0best approach?
> [Jack] You should register your HBA to SCST (the one I most familiar =
and
> powerful)
> as a target driver. And only if you want the HBA can be initiator and=
 target
> at the same time you can register the HBA to SCSI ML as a LLD.
>> [iscsilearner]  Sure I register with SCST for linux based storage se=
rvers.  But my original question is about "linux running on this HBA it=
self".  Within this HBA I need to filter out SCSI CDB  from  the open-s=
ource initiator iscsi stacks, is SCSI ML LLD right place to do this ?

>
> In my case the LLD =A0will then pass that SCSI command/data across th=
e
> PCIe to storage server. =A0 To be more clear this LLD will be running
> ON a PCIe HBA
>
> The target mode iSCSI stack can be any one of the popular linux iSCSI
> target stacks.
>
>
> Thanks much in advance
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
