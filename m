From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SCSI: Fix hard lockup in scsi_remove_target()
Date: Fri, 02 Oct 2015 15:09:33 +0200
Message-ID: <mqdoagh5sdu.fsf@c203.arch.suse.de>
References: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
	<20151002124903.GA11987@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbJBNJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 09:09:35 -0400
In-Reply-To: <20151002124903.GA11987@infradead.org> (Christoph Hellwig's
	message of "Fri, 2 Oct 2015 05:49:03 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

>> -	list_for_each_entry(starget, &shost->__targets, siblings) {
>> +	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings=
) {
>>  		if (starget->state =3D=3D STARGET_DEL)
>>  			continue;
>>  		if (starget->dev.parent =3D=3D dev || &starget->dev =3D=3D dev) {
>>  			/* assuming new targets arrive at the end */
>
> Now that the last variable is gone this comments isn't needed.

Yep, you're right. I'll remove it.

>
>>  			kref_get(&starget->reap_ref);
>>  			spin_unlock_irqrestore(shost->host_lock, flags);
>> -			if (last)
>> -				scsi_target_reap(last);
>> -			last =3D starget;
>> +
>>  			__scsi_remove_target(starget);
>> +			list_move_tail(&starget->siblings, &reap_list);
>>  			spin_lock_irqsave(shost->host_lock, flags);
>>  		}
>
> What makes the list_move save after dropping host_lock?  I think this
> needs to be changed to not drop the host_lock and change
> __scsi_remove_target to expect host_lock held to be safe.=20

Having the list_move() outside of the host_lock was purely by
accident. Interestingly the stressing didn't mind it. But yes you're
right, __scsi_remove_target() should be made host_lock() save for being
called under the host_lock.

Regarding the list move, does it look OK for you (i.e. do we still need
it after reworking __scsi_remove_target())? IMHO yes, but I only have
half a year of experience in this area).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
