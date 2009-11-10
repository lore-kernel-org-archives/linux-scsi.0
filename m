From: "jack wang" <jack_wang@usish.com>
Subject: Re: [PATCH 6/7]MVSAS: Enhanced hot plug handling
Date: Tue, 10 Nov 2009 10:51:35 +0800
Message-ID: <B1E71B5F48E14D58AD0DBE2A3CCD893F@usish.com.cn>
References: <20091109122713.GE32336@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:55604 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZKJCvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 21:51:31 -0500
In-Reply-To: <20091109122713.GE32336@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com, james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com

+
spin_unlock_irqrestore(dev->sata_dev.ap->lock,
+						flags_libsas);
+				spin_unlock_irqrestore(&mvi->lock, flags);
+				t->task_done(t);
+				spin_lock_irqsave(&mvi->lock, flags);
+				spin_lock_irqsave(dev->sata_dev.ap->lock,
+					flags_libsas);


[Jack] Is there something wrong with the the lock sequence .
for sata io path, will __acquires(dev->sata_dev.ap->lock) when issue cmd to
lldd
and you acquires your mvi lock then, so should you change the lock sequence
to :


spin_unlock_irqrestore(&mvi->lock, flags);
spin_unlock_irqrestore(dev->sata_dev.ap->lock,
						flags_libsas);
t->task_done(t);
spin_lock_irqsave(dev->sata_dev.ap->lock,
					flags_libsas);
spin_lock_irqsave(&mvi->lock, flags);



