From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 10/20] qla2xxx: Fix interaction issue between qla2xxx
 and Target Core Module
Date: Wed, 9 Dec 2015 22:41:11 +0000
Message-ID: <D28DE5C9.1B194%quinn.tran@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
 <5667D1BA.6070106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5667D1BA.6070106@suse.de>
Content-Language: en-US
Content-ID: <F830C353B2F8C549BCBD2D14132CBA29@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Himanshu Madhani <himanshu.madhani@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hannes,

ACK.  We=B9ll move the flags to bitops in the "follow on" patch to clea=
n it
up.  Those flags was introduced from a different patch. Will move the f=
ew
overloaded flag to bit field.

However, getting rid of the spin lock would prove tricky because the co=
de
is trying to serialize the cleanup.  With out the lock, we kept hitting
multiple free problem.

Regards,
Quinn Tran




On 12/8/15, 11:01 PM, "target-devel-owner@vger.kernel.org on behalf of
Hannes Reinecke" <target-devel-owner@vger.kernel.org on behalf of
hare@suse.de> wrote:

>>+
>>  }
>> =20
>>  static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport =
*,
>Have you considered moving to bit ops when modifying cmd_flags?
>I guess you can also move the ->aborted bit into the bit field, and
>could get rid of some of the spinlocks ...
>
>Cheers,
>
>Hannes
>--=20
>Dr. Hannes Reinecke		      zSeries & Storage
>hare@suse.de			      +49 911 74053 688
>SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>--
