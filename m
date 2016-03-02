From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RESEND] scsi_sysfs: add 'is_bin_visible' callback
Date: Wed, 2 Mar 2016 15:33:14 +0800
Message-ID: <56D6973A.4070901@suse.de>
References: <1456807945-88857-1-git-send-email-hare@suse.de>
 <20160301130448.GB7616@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbcCBHd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 02:33:28 -0500
In-Reply-To: <20160301130448.GB7616@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 03/01/2016 09:04 PM, Christoph Hellwig wrote:
> On Tue, Mar 01, 2016 at 05:52:25AM +0100, Hannes Reinecke wrote:
>> +	struct device *dev =3D container_of(kobj, struct device, kobj);
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);
>> +
>> +
>> +	rcu_read_lock();
>> +	if (attr =3D=3D &dev_attr_vpd_pg80 &&
>> +	    !rcu_dereference(sdev->vpd_pg80)) {
>> +		rcu_read_unlock();
>> +		return 0;
>> +	}
>> +	if (attr =3D=3D &dev_attr_vpd_pg83 &&
>> +	    !rcu_dereference(sdev->vpd_pg83)) {
>> +		rcu_read_unlock();
>> +		return 0;
>> +	}
>> +	rcu_read_unlock();
>=20
> We are only checking the pointers for being non-zero.  No need for th=
e
> rcu_read_lock() or rcu_dereference() here.
>=20
Better to be same than sorry; some overly clever code analysis tool
might trip over it otherwise.

> Otherwise this looks fine to me.

Reviewed-by: ?

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
