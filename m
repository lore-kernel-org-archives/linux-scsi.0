From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 4/5] bnx2fc: Check sc_cmd device and host pointer before returning the command to the mid-layer.
Date: Thu, 07 Apr 2016 16:00:24 +0200
Message-ID: <4304901.GbWEH60R4p@c203>
References: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com> <1460034480-28512-5-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbcDGOAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 10:00:31 -0400
In-Reply-To: <1460034480-28512-5-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

On Donnerstag, 7. April 2016 09:07:59 CEST Chad Dupuis wrote:
> When we are in connection recovery and the internal command timer on =
a
> request pops, either the scsi_cmnd->device or scsi_cmnd->device->host=
 back
> pointers may be NULL as the device that the command that the request =
was
> submitted on may have been subsequently reaped due to the connection
> recovery. This can cause one or both of the pointers above to be NULL=
 and
> cause a system crash if we try to return the command to the midlayer.
>=20
> Instead, double check the pointers before the return to the midlayer =
so as
> to prevent the crash and let the upper layers finish the session reco=
very
> and rediscover the device.
>=20
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
