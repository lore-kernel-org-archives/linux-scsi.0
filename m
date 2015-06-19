From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] target: Send UA when changing LUN inventory
Date: Fri, 19 Jun 2015 15:10:00 +0200
Message-ID: <558414A8.2000607@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-7-git-send-email-hare@suse.de> <20150619130733.GC7783@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150619130733.GC7783@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/19/2015 03:07 PM, Christoph Hellwig wrote:
>> +		hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
>> +			if (tmp =3D=3D new)
>> +				continue;
>> +			core_scsi3_ua_allocate(tmp, 0x3F,
>> +				ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
>> +		}
>> +		rcu_read_unlock();
>> +
>=20
>> +	rcu_read_lock();
>> +	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
>> +		if (tmp =3D=3D new)
>> +			continue;
>> +		core_scsi3_ua_allocate(tmp, 0x3F,
>> +			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
>> +	}
>> +	rcu_read_unlock();
>=20
>> +
>> +	rcu_read_lock();
>> +	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link)
>> +		core_scsi3_ua_allocate(tmp, 0x3F,
>> +			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
>> +	rcu_read_unlock();
>=20
> Please add a helper instead of duplicating this three times.
>=20
Okay.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
