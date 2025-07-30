Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC95B26D4F9
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 15:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753890255; cv=none; b=hEvvzALLQ8kHLmXbr9PTFn2DBhFkbcgSC0VRmyzeOWCMlV9eu/3HZav1wZV7a/0CBqzjiA3lHp1z6c7p8mKYfBZ7/gJY2gBFppG8HcgjSs9G6Scy3R6BLMcfKD0JnC96oOLg7cZQeUnCGL/uDVXOgAoYKb2v1Ki8zlNbrLhBzV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753890255; c=relaxed/simple;
	bh=dIC6ZiiJLCATn2aEYXAbpEgT7yRi9w27BFSgneF2QG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mB0Pdiyp6WZlxZP3Vq55Fv+gk+WYy2iSME5JO0yZTRRqLfj0g4G1fACi/0nXKKIZzWmrUdGO4uvS1UAxgIU2qrLz6xBTuMijJlbWHzgPJf0ka5LJbc2fo2/OOzm8PClsjRXyQDOG7SxfP4XDqQYbdQb84w3bV3ey6hdLbu6eNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+bQTE40; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+bQTE40"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753890252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HX7tF362TSeYajHYNsWX4IpMPfRgzNyrPz6eFnUfIs=;
	b=S+bQTE40zo+s8vVa9FM08M6IsL4aTYBc9zLnYeVkj3Ix4t5WFD+B7IRYqvVmHCNgWpl76A
	w8W9cqd63pWuVY0ZVazrQ9KXDV6C18fGJo6bE+CblbCpso+fKvDNm+OB0pqKRFnhfkYCCi
	qtfXik/oKqPYfyNo+95+RmGllLuEFGs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658--NWqE5t6PzuZbCAj37kBuA-1; Wed, 30 Jul 2025 11:44:10 -0400
X-MC-Unique: -NWqE5t6PzuZbCAj37kBuA-1
X-Mimecast-MFC-AGG-ID: -NWqE5t6PzuZbCAj37kBuA_1753890250
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7892c42b7so2207966f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 08:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753890248; x=1754495048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HX7tF362TSeYajHYNsWX4IpMPfRgzNyrPz6eFnUfIs=;
        b=xQyaAWrK01w3YQYa+FO1Q19fhvfiJ4n/dEmZJDUPxZ7x4lFcN3sq2gn94WwDX37mEk
         HRukIgulm52u6Y0fGZiWgu7jpBh8J3x1G4M5sMZWUvHNwidyxdliUggt3+5QpmfyyXga
         72O19I20ET//CGUSUMhXOLSOnKltb3DUfKUnXv/TS5wqBUz+tIeSSabAkzMQo5LCLnAt
         foEdGwWYMcNm8WOrmq8+D+7xUxllP43+pZe0HDm3JCrq8wfmlbRAwGRwYk54LEh/lSUp
         9J8eJf2RiOonm4sd1yGdvtZsM8M0dkU+Wbe3omExELoub4TQ7ouOW+aP95rQ78A/TK9T
         frFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXm5WHZKlsLbRW12GIC+VGyoFfMEzzBBGK04IAhfkVYL/J4mrsbgpL3TQeGL2VteDsCx6mdwGgEYN5t@vger.kernel.org
X-Gm-Message-State: AOJu0YyGy4tRXSPAXB6i8iTgXeOhk6TQGHN60j8wvSC5zuxlSLE2Vyza
	0lHDZelJ93WezVmBylRtmwo7WJUlpUrEEHhh2p2Zs7e+snD5AlrBDjTD/aoboj6ovAEc/vHw32q
	/SCCGyLPs+Jotcly7sIh9eaCxdbEncpV1/d3ZwgIH/uurBdesoIQ0GgrKmgmygExfr/uuwbCx3s
	LwdqZLskQ3NCcpnpdD6VgFMTscsNvCU4i4CrAUdA==
X-Gm-Gg: ASbGncu/e2SPrv2afp88RcHXKt6bIDVatSBMzpEZNoB4MX6GJrCzuHFaxxxA1znkYZo
	pld1Q1eeGcl96s4KOBNKPdrgAxJg9+QDo45zIEPM0EJhUw/Hkt3EmBeO9GkcfdSjAcB5GSQBTY8
	j/VrThbLM6zsbHRPIXaMr+Eg==
X-Received: by 2002:a05:6000:288b:b0:3b7:9350:44d4 with SMTP id ffacd0b85a97d-3b794fc2be0mr3119868f8f.11.1753890247835;
        Wed, 30 Jul 2025 08:44:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoLlLj9O2vn2HKZAx3EicapBRkBqUgFETWiZtsSxqaHMeqqbRpulPD3KvMXfTkj/NZN6DdDyZiFIlCTp+YhAU=
X-Received: by 2002:a05:6000:288b:b0:3b7:9350:44d4 with SMTP id
 ffacd0b85a97d-3b794fc2be0mr3119848f8f.11.1753890247461; Wed, 30 Jul 2025
 08:44:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725212732.2038027-2-cleech@redhat.com> <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com> <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
 <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com> <aIgNUw8IfNGOz3tl@my-developer-toolbox-latest>
 <f9525216-5721-4f9e-99ab-d697506e0e8f@embeddedor.com> <6d8f13c8-405f-4fa0-ad23-09c9e4c5cd54@embeddedor.com>
 <22825ff4-0545-4e6b-92a6-64ddfac82b55@embeddedor.com>
In-Reply-To: <22825ff4-0545-4e6b-92a6-64ddfac82b55@embeddedor.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Wed, 30 Jul 2025 11:43:54 -0400
X-Gm-Features: Ac12FXzRyh4uM52E8k5ajExwrkZ5U4nZwMppnvP5GWh9XUgWJ3fcCpDB5ViCjks
Message-ID: <CAHhmqcSzwnz+jir+vMjH2j7k+4JtyJ5wvr0deLXJvinSiSKzCg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array purex_item.iocb
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org, 
	Nilesh Javali <njavali@marvell.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, John Meneghini <jmeneghi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Yes, it passes.  When I test this on top of the NVMe FPIN link
integrity v9 patchset, I only see the "kernel: qla2xxx... : FPIN ELS"
event.

Tested-by: Bryan Gurney <bgurney@redhat.com>


Thanks,

Bryan

On Tue, Jul 29, 2025 at 11:45=E2=80=AFPM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> Hi Bryan,
>
> I wonder if you could run your tests on the patch below and let me
> know if it passes. If it does, I'll go ahead and submit it as a
> proper patch (including your Tested-by tag) to the SCSI list.
>
> Thank you!
> -Gustavo
>
> >
> > The (untested) patch below avoids the use of `struct_group_tagged()`
> > and the casts to `struct purex_item *`:
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_=
def.h
> > index cb95b7b12051..4bdf8adf04ed 100644
> > --- a/drivers/scsi/qla2xxx/qla_def.h
> > +++ b/drivers/scsi/qla2xxx/qla_def.h
> > @@ -4890,9 +4890,7 @@ struct purex_item {
> >                               struct purex_item *pkt);
> >          atomic_t in_use;
> >          uint16_t size;
> > -       struct {
> > -               uint8_t iocb[64];
> > -       } iocb;
> > +       uint8_t iocb[] __counted_by(size);
> >   };
> >
> >   #include "qla_edif.h"
> > @@ -5101,7 +5099,6 @@ typedef struct scsi_qla_host {
> >                  struct list_head head;
> >                  spinlock_t lock;
> >          } purex_list;
> > -       struct purex_item default_item;
> >
> >          struct name_list_extended gnl;
> >          /* Count of active session/fcport */
> > @@ -5130,6 +5127,10 @@ typedef struct scsi_qla_host {
> >   #define DPORT_DIAG_IN_PROGRESS                 BIT_0
> >   #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
> >          uint16_t dport_status;
> > +
> > +       TRAILING_OVERLAP(struct purex_item, default_item, iocb,
> > +               uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
> > +       );
> >   } scsi_qla_host_t;
> >
> >   struct qla27xx_image_status {
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_=
isr.c
> > index c4c6b5c6658c..4559b490614d 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -1077,17 +1077,17 @@ static struct purex_item *
> >   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
> >   {
> >          struct purex_item *item =3D NULL;
> > -       uint8_t item_hdr_size =3D sizeof(*item);
> >
> >          if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> > -               item =3D kzalloc(item_hdr_size +
> > -                   (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> > +               item =3D kzalloc(struct_size(item, iocb, size), GFP_ATO=
MIC);
> >          } else {
> >                  if (atomic_inc_return(&vha->default_item.in_use) =3D=
=3D 1) {
> >                          item =3D &vha->default_item;
> >                          goto initialize_purex_header;
> >                  } else {
> > -                       item =3D kzalloc(item_hdr_size, GFP_ATOMIC);
> > +                       item =3D kzalloc(
> > +                               struct_size(item, iocb, QLA_DEFAULT_PAY=
LOAD_SIZE),
> > +                               GFP_ATOMIC);
> >                  }
> >          }
> >          if (!item) {
> > @@ -1127,17 +1127,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, =
struct purex_item *pkt,
> >    * @vha: SCSI driver HA context
> >    * @pkt: ELS packet
> >    */
> > -static struct purex_item
> > -*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
> > +static struct purex_item *
> > +qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
> >   {
> >          struct purex_item *item;
> >
> > -       item =3D qla24xx_alloc_purex_item(vha,
> > -                                       QLA_DEFAULT_PAYLOAD_SIZE);
> > +       item =3D qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE=
);
> >          if (!item)
> >                  return item;
> >
> > -       memcpy(&item->iocb, pkt, sizeof(item->iocb));
> > +       memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
> >          return item;
> >   }
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla=
_nvme.c
> > index 8ee2e337c9e1..92488890bc04 100644
> > --- a/drivers/scsi/qla2xxx/qla_nvme.c
> > +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> > @@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struc=
t rsp_que **rsp)
> >
> >          ql_dbg(ql_dbg_unsol, vha, 0x2121,
> >                 "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
> > -              item->iocb.iocb[3], item->size, uctx->exchange_address,
> > +              item->iocb[3], item->size, uctx->exchange_address,
> >                 fcport->d_id.b24);
> >          /* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
> >           * ----- -----------------------------------------------
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_o=
s.c
> > index d4b484c0fd9d..253f802605d6 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -6459,9 +6459,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_h=
ost *vha,
> >   void
> >   qla24xx_free_purex_item(struct purex_item *item)
> >   {
> > -       if (item =3D=3D &item->vha->default_item)
> > +       if (item =3D=3D &item->vha->default_item) {
> >                  memset(&item->vha->default_item, 0, sizeof(struct pure=
x_item));
> > -       else
> > +               memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_=
PAYLOAD_SIZE);
> > +       } else
> >                  kfree(item);
> >
> > Thanks
> > -Gustavo
>

