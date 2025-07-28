Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA546D27E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 23:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753746784; cv=none; b=itVyRRaFa1anzZRLYTnGxM12tMgYhLoeHPgwq0HDTT28MY9gJaqRsjyJ2mbk3WYgnt4q2u8kc54mBWW+FhwsHRU+ZcffkJNCGi+z+JraeBVyxkG003e3lv9IQYA9/jX91O8IP4hijIFvslC6fAPmGvpNiMNYpq/sDXit3Usq6lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753746784; c=relaxed/simple;
	bh=ZXgIGZSIRAJimrGhAgdxG2nfUguy5Ps6O02R3X1pAaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY8KtH6h8TdpBTdfKPcm3MwyFQshZ/V1UzchFsZKi/4kXoNQe8INS5Ita+eTxKtcT3hwTgW1YqXGIP66e1bWyBtLKf+e1dk8Lyl0E+wiGcuziHCbGhZPo0Kv9LKVgQOudpIQD5zZuQmldbfauV8jK9HmP5p29F7fxD4FcqQrwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iE6wDCQr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iE6wDCQr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753746781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6S/n5Azyzj2b9qcPojXBRUfuZvcGNhlMNlI0MWB7iu0=;
	b=iE6wDCQrvYKj7W5u44oDfpee/63pPVUhgjLXZnTbrJgSI3Ih+4tRLcKMph52FaRylt+rx6
	7Ro3PX7c5fZej5Buv2R2ALb4/v3LadmG0CynPFKbeAKhDS/zdrwfpea93HpvhNrvV5Q8DY
	DPrIoNjwgNk5qSf5UfZXGExkQjxGh9M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-PtNtd3AxN5iPoNc1KnNdeg-1; Mon,
 28 Jul 2025 19:52:58 -0400
X-MC-Unique: PtNtd3AxN5iPoNc1KnNdeg-1
X-Mimecast-MFC-AGG-ID: PtNtd3AxN5iPoNc1KnNdeg_1753746777
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE7BD19560AD;
	Mon, 28 Jul 2025 23:52:56 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C70291955F21;
	Mon, 28 Jul 2025 23:52:54 +0000 (UTC)
Date: Mon, 28 Jul 2025 16:52:51 -0700
From: Chris Leech <cleech@redhat.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
	Kees Cook <kees@kernel.org>, Bryan Gurney <bgurney@redhat.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible
 array purex_item.iocb
Message-ID: <aIgNUw8IfNGOz3tl@my-developer-toolbox-latest>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
 <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
 <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Jul 28, 2025 at 04:55:12PM -0600, Gustavo A. R. Silva wrote:
> 
> 
> On 28/07/25 15:15, Chris Leech wrote:
> > On Mon, Jul 28, 2025 at 01:43:10PM -0600, Gustavo A. R. Silva wrote:
> > > On 28/07/25 12:57, Chris Leech wrote:
> > > > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> > > > index fe98c76e9be32..a00c06a9898ec 100644
> > > > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > > > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > > > @@ -1077,17 +1077,17 @@ static struct purex_item *
> > > >    qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
> > > >    {
> > > >    	struct purex_item *item = NULL;
> > > > -	uint8_t item_hdr_size = sizeof(*item);
> > > >    	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> > > > -		item = kzalloc(item_hdr_size +
> > > > -		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> > > > +		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
> > > 
> > > With the inclusion of `counted_by`, I think `item->size` should be updated
> > > here:
> > > 		item->size = size;
> > > 
> > > >    	} else {
> > > >    		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
> > > > -			item = &vha->default_item;
> > > > +			item = (struct purex_item *)&vha->default_item;
> > > >    			goto initialize_purex_header;
> > > >    		} else {
> > > > -			item = kzalloc(item_hdr_size, GFP_ATOMIC);
> > > > +			item = kzalloc(
> > > > +				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
> > > > +				GFP_ATOMIC);
> > > 
> > > ...and here:
> > > 			item->size = QLA_DEFAULT_PAYLOAD_SIZE;
> > > 
> > > Then remove `item->size = size;` just before `return item;`
> > 
> > Hmm, I don't think I agree with that. The single assignment before
> > returning just keeps the allocation failure check in one place.
> > The conditional nesting in this function is a little odd, but I don't
> > want to start reworking it completly for this.
> > 
> > Is there a problem with the size referenced by counted_by potentially
> > being smaller than the allocation?  That looks possible in the case of
> > using the single pre-allocated default_item, but not needing to use the
> > entire 64-bytes (I don't know if that happens).
> 
> But if both allocations for `struct purex_item *item` fail, then
> you'd end up with a flexible-array member of size 0, and `item->size`
> potentially being greater than zero, since `default_item` doesn't
> contain `uint8_t iocb[64];` anymore (it was turned into flex-array
> member `uint8_t iocb[] __counted_by(size);`)... unless I'm missing
> something?

This might be confusing to see as a diff; qla24xx_alloc_purex_item is
either allocating a new heap item with a flexible array size, or if the
size is small enough and there is only one in use at a time it's
returning default_item.

If the allocation fails, then the driver is already not using
default_item for this call and returns NULL.

  static struct purex_item *
  qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
  {
      struct purex_item *item = NULL;

      if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
          item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
      } else {
          if (atomic_inc_return(&vha->default_item.in_use) == 1) {
              item = (struct purex_item *)&vha->default_item;
              goto initialize_purex_header;
          } else {
              item = kzalloc(
                  struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
                  GFP_ATOMIC);
          }
      }
      if (!item) {
          ql_log(ql_log_warn, vha, 0x5092,
                 ">> Failed allocate purex list item.\n");

          return NULL;
      }

  initialize_purex_header:
      item->vha = vha;
      item->size = size;
      return item;
  }


default item was replaced with the header and a static sized array,
cast to a purex_item * when returned through the alloc function

  -       struct purex_item default_item;
  +       struct purex_item_hdr default_item;
  +       uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];

- Chris

