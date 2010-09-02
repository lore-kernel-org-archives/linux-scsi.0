From: Hannes Reinecke <hare@suse.de>
Subject: Re: question about drivers/scsi/scsi_transport_fc.c
Date: Thu, 02 Sep 2010 15:39:39 +0200
Message-ID: <4C7FA91B.60607@suse.de>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk> <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0IBNjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2010 09:39:40 -0400
In-Reply-To: <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Julia Lawall <julia@diku.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, joe@perches.com, James Smart <James.Smart@Emulex.Com>

Christof Schmitt wrote:
> On Sat, Aug 28, 2010 at 07:11:12PM +0200, Julia Lawall wrote:
>> The function fc_bsg_goose_queue in the file drivers/scsi/scsi_transp=
ort_fc.c
>> contains the following code:
>>
>>         flagset =3D test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->que=
ue_flags) &&
>>                   !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queu=
e_flags);
>>
>> I have the impression that this is always 0.  QUEUE_FLAG_REENTER is=20
>> defined with quite a lot of other constants, so I don't really have =
a=20
>> guess as to what was intended.
>=20
> I just came across the code in scsi_run_queue in
> drivers/scsi/scsi_lib.c. It looks like the check of QUEUE_FLAG_REENTE=
R
> in fc_bsg_goose_queue is modeled after the check in scsi_run_queue.
>=20
> The check in scsi_run_queue has been introduced with this commit,
> maybe this helps understanding the code:
>=20
> commit 04846f25920d4b05d6040c531cc601049260db52
> Author: Andreas Herrmann <aherrman@de.ibm.com>
> Date:   Wed Aug 9 17:31:16 2006 +0200
>=20
>     [SCSI] limit recursion when flushing shost->starved_list
>=20
Then it's still wrong. The above commit has:

+               if (test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
+                   !test_and_set_bit(QUEUE_FLAG_REENTER,
+                                     &sdev->request_queue->queue_flags=
)) {

Which is slightly different than the above. Looks like a copy and past =
error.
It probably should read

         flagset =3D test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue=
_flags) &&
                   !test_and_set_bit(QUEUE_FLAG_REENTER, &rport->rqst_q=
->queue_flags);

This was introduced by

commit 9e4f5e29610162fd426366f3b29e3cc6e575b858
Author: James Smart <James.Smart@Emulex.Com>
Date:   Thu Mar 26 13:33:19 2009 -0400

    [SCSI] FC Pass Thru support

so we should be blaming^Wasking him.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
