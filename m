Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3C5366DDD
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772215935; cv=none; b=Q4SRZq883rdwostVWpQ5GFhkI7YyQ3zp00Ia9s9TGt8FM6Z3d8bXMJt5ol7nT/yFDgwD0A+tp9Q5BIgIxDQPSLPcorKoNniL5eRMJxmX5UK5Zsxxnzl0Vo/1TqPfrtkn+vcvBBUVrz3JmWg201v0xavH75Vg+4cdD6696m/mZYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772215935; c=relaxed/simple;
	bh=LhWoa3Gc15gL8xOlC3I0r2uKc6Y2oNYr1JgGUU8tc8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVWO687vBpV4o4qVjdwFH70JmvWfaKh7cM5gKyaNCLAoY6psefxO/KrQuc75v8PsWYlzgaW0asvRdByXepO1UMhVJl8gptu9koMRHmj205m819ju+Jh62LC/xa7o+/IyCEwwECLC2I29dY3FioCLnFJsod6P27QTNsCKqoPAA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fqCs1Qqf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqCs1Qqf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772215932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iG5lt5XxO/hh9xVt2TbhtRpf4Oxa4xmbAazMvGovJ3Q=;
	b=fqCs1Qqf4n35hwzd2bnt589fUjuzSBEtycA1xHY7jYHKumVj0imiBj40cfJFlAr63Rx+Tz
	iDJDXwYL15L/ok2aWpUviCbuoqE6djI4iqR+q21SMBpgKKoAemoJxAC7rDsRfzUP6tH0n3
	ULkkIZXXEt+ruusdD4ws8lCOMw+HAC0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-omPVtsOgMy-QsqCfcc6GHw-1; Fri,
 27 Feb 2026 13:12:09 -0500
X-MC-Unique: omPVtsOgMy-QsqCfcc6GHw-1
X-Mimecast-MFC-AGG-ID: omPVtsOgMy-QsqCfcc6GHw_1772215927
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFC28180025E;
	Fri, 27 Feb 2026 18:12:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FC081800286;
	Fri, 27 Feb 2026 18:12:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61RIC3Le1740709
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 13:12:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61RIC2001740708;
	Fri, 27 Feb 2026 13:12:02 -0500
Date: Fri, 27 Feb 2026 13:12:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, hch@lst.de, sagi@grimberg.me,
        axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] libmultipath: Add PR support
Message-ID: <aaHecneNg9Q8EtiS@redhat.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-10-john.g.garry@oracle.com>
 <aZ8Z7A4uOFfOTDeY@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ8Z7A4uOFfOTDeY@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 25, 2026 at 08:49:00AM -0700, Keith Busch wrote:
> On Wed, Feb 25, 2026 at 03:32:21PM +0000, John Garry wrote:
> > +static int mpath_pr_register(struct block_device *bdev, u64 old_key,
> > +			u64 new_key, unsigned int flags)
> > +{
> > +	struct mpath_disk *mpath_disk = dev_get_drvdata(&bdev->bd_device);
> > +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> > +	struct mpath_device *mpath_device;
> > +	int srcu_idx, ret = -EWOULDBLOCK;
> > +
> > +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
> > +	mpath_device = mpath_find_path(mpath_head);
> > +	if (mpath_device)
> > +		ret = mpath_head->mpdt->pr_ops->pr_register(mpath_device,
> > +				old_key, new_key, flags);
> > +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
> 
> Instead of having the lower layer define new mp template functions, why
> not use the existing pr_ops from mpath_device->disk->fops->pr_ops?

I don't think that's the right answer. The regular scsi persistent
reservation functions simply won't work on a multipath device. Even just
a simple reservation fails.

For example (with /dev/sda being multipath device 0):
# echo round-robin > /sys/class/scsi_mpath_device/0/iopolicy
# blkpr -c register -k 0x1 /dev/sda
# blkpr -c reserve -k 0x1 -t exclusive-access-reg-only /dev/sda
# dd if=/dev/sda of=/dev/null iflag=direct count=100
dd: error reading '/dev/sda': Invalid exchange
1+0 records in
1+0 records out
512 bytes copied, 0.00871312 s, 58.8 kB/s

Here are the kernel messages:
[ 3494.660401] sd 7:0:1:0: reservation conflict
[ 3494.661802] sd 7:0:1:0: [sda:1] tag#768 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[ 3494.664848] sd 7:0:1:0: [sda:1] tag#768 CDB: Read(10) 28 00 00 00 00 01 00 00 01 00
[ 3494.667092] reservation conflict error, dev sda:1, sector 1 op 0x0:(READ) flags 0x2800800 phys_seg 1 prio class 2

If you don't have a multipathed scsi device to try this on, you can run:

targetcli <<EOF
/backstores/ramdisk create mptest 1G
/loopback create naa.5001401111111111
/loopback create naa.5001402222222222
/loopback create naa.5001403333333333
/loopback create naa.5001404444444444
/loopback/naa.5001401111111111/luns create /backstores/ramdisk/mptest
/loopback/naa.5001402222222222/luns create /backstores/ramdisk/mptest
/loopback/naa.5001403333333333/luns create /backstores/ramdisk/mptest
/loopback/naa.5001404444444444/luns create /backstores/ramdisk/mptest
EOF

to create one.

Handling scsi Persistent Reservations on a multipath device is painful.
Here is a non-exhaustive list of the problems with trying to make a
multipath device act like a single scsi device for persistent
reservation purposes:

You need to register the key on all the I_T Nexuses. You can't just pick
a single path. Otherwise, when you set up the reservation, you will only
be able to do IO on one of the paths. That's what happened above.

If an path is down when you do the resevation, you might not be able to
register the key on that path. You certainly can't do it directly.
Using the All Target Ports bit (assuming the device supports it) could
let you extend a reservation from one target port to others, assuming
your path isn't down because of connection issue on the host side. But
in general, you have to be able to handle the case where you can't
register (or unregister) a key on your failed paths. If you don't do
that (un)registration when the path comes up, before it can get seleted
for handling IO, you will fail when accessing a path you should be
allowed allowed to access, or succeed in accessing a path that you are
should not be allowed to access.

The same is true when new paths are discovered. You need to register
them.

Except that a preempt can come and remove your registration at any time.
You can't register the new (or newly active) path if the key has been
preempted, and this preemption can happen at any moment, even after you
check if the other paths are still registered. If this isn't handled
correctly, paths can access storage that they should not be allowed to
access.

Changing the reservation type (for instance from
exclusive-access-reg-only to write-exclusive-reg-only) in scsi devices
is done by preempting the existing reservation. This will remove the
registered keys from every path except the one issuing the command. The
key needs to be reregistered on all the other paths again. If any IO
goes to these paths before they are reregistered, it will fail with a
reservation conflict, so IO needs to be suspended during this time.

The path that is holding the reservation might be down. In this case,
you aren't able to release the reservation from that path. The only way
I figured out to handle this in dm-mpath was for the device to preempt
it's own key, to move the reservation to a working path. This causes the
same issues as preempting key to change the reservation type, where you
need to reregister all the paths with IO suspended.

An actual preemption can come in from another machine while you are
doing this. In that case, you must not reregister the paths, and if you
already started, you must unregister them.

I can probably come up with more issues.

I think the best course of action for now is to just fail persistent
reservations as non-supported for scsi devices. IMHO Making them work
correctly (where mulitpath device IO won't fail when it should succeed,
and succeed when it should fail with a reservation conflict) dwarfs the
amount of work necessary to support ALUA.

dm-mpath previously did a pretty good job handling Persistent
Reservations. But recently it became much better, because it become very
clear that pretty good is not good enough for what people what to do
with Persistent Reservations and multipath devices.

-Ben

