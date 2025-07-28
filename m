Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A400E2E3708
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753737321; cv=none; b=rJJfWUrN6KejjOGmbjCFBXtlc0CU1wRi4u7ZE22w4VdjL1x7fJxmCuVJo6gpmAxmCJFqAKIO8SN+GmYnxQFYOEsTavQHfpmUxyzq7kR3M5IK8zjZ7igy4HAU9+uqTHYnekXd/yDElSJveqTQfp76cMtjbcLEkPCNie5SOfd+qYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753737321; c=relaxed/simple;
	bh=7YCr/BI0V1exliX8uMWZpL//Cl1ab4ic96b+eUfW9s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpcknQdhlHip45gr5wg2OUKa74igZXHMli84g25ZYFwcefQ/+PnFKVlR1pklsNwjwPASb+Ipthy6/n8CmNHhW+YmEwmzGp6tPyhiSxLEXQsKLc+Seid3l8LFS3neZhS7yHTg4+qCLcOdVUSYJS6fpVCSY8cS+kRzTpHqDe7Kjqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6LcpL2Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6LcpL2Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753737317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YOiH+OPMuIGkAD2Owl47JAsoBYaMh5LQK2mDPjRCWcw=;
	b=U6LcpL2ZGyI93n9U81i/MELftG6yLCkyLAL9LcwFoJ6nToNEfr128zDGYkPD7A2ALog4m0
	mkQ5octEhoN+DU0UGSlbYDPb7IACNJ2zTNnERrsaY3DkSeWpSulb2Pjx8m8gY/QIBALm6f
	RrMqOIXrYbd6LpfuFJ2cxV27PqMA12M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-DJ0RjMILPjC5nn3DMjKl6w-1; Mon,
 28 Jul 2025 17:15:14 -0400
X-MC-Unique: DJ0RjMILPjC5nn3DMjKl6w-1
X-Mimecast-MFC-AGG-ID: DJ0RjMILPjC5nn3DMjKl6w_1753737311
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70C3519560B2;
	Mon, 28 Jul 2025 21:15:11 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3D861955F16;
	Mon, 28 Jul 2025 21:15:09 +0000 (UTC)
Date: Mon, 28 Jul 2025 14:15:06 -0700
From: Chris Leech <cleech@redhat.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
	Kees Cook <kees@kernel.org>, Bryan Gurney <bgurney@redhat.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible
 array purex_item.iocb
Message-ID: <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Jul 28, 2025 at 01:43:10PM -0600, Gustavo A. R. Silva wrote:
> On 28/07/25 12:57, Chris Leech wrote:
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> > index fe98c76e9be32..a00c06a9898ec 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -1077,17 +1077,17 @@ static struct purex_item *
> >   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
> >   {
> >   	struct purex_item *item = NULL;
> > -	uint8_t item_hdr_size = sizeof(*item);
> >   	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> > -		item = kzalloc(item_hdr_size +
> > -		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> > +		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
> 
> With the inclusion of `counted_by`, I think `item->size` should be updated
> here:
> 		item->size = size;
> 
> >   	} else {
> >   		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
> > -			item = &vha->default_item;
> > +			item = (struct purex_item *)&vha->default_item;
> >   			goto initialize_purex_header;
> >   		} else {
> > -			item = kzalloc(item_hdr_size, GFP_ATOMIC);
> > +			item = kzalloc(
> > +				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
> > +				GFP_ATOMIC);
> 
> ...and here:
> 			item->size = QLA_DEFAULT_PAYLOAD_SIZE;
> 
> Then remove `item->size = size;` just before `return item;`

Hmm, I don't think I agree with that. The single assignment before
returning just keeps the allocation failure check in one place.
The conditional nesting in this function is a little odd, but I don't
want to start reworking it completly for this.

Is there a problem with the size referenced by counted_by potentially
being smaller than the allocation?  That looks possible in the case of
using the single pre-allocated default_item, but not needing to use the
entire 64-bytes (I don't know if that happens).

- Chris

