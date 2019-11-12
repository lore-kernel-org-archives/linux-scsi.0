Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E74C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 11:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE78D2084E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 11:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B16kGHPn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfKLLLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 06:11:10 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48108 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726994AbfKLLLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 06:11:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573557068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCDzF3I7PqpWpcWmCXsJTENxJT/HWr5M11CK6M+e5Cc=;
        b=B16kGHPnd95n8Xe3qSMrPaq48oN+aRuBisdYiHXy95isDUr7h0qQMTgn/Vd6sPgusJtOMv
        jt6pp8bTbusJZaTs4HjOKOQkOxcPrVIsNHofmjhAT7qhWZ/dF366c1bAG+EkB/31OVJfu7
        SDL4GDj7ZIjQoUkmbqSSQEkd3F2+ssM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-vGqH9W-0N8G3pcQ8is3d0w-1; Tue, 12 Nov 2019 06:11:05 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BB122F29;
        Tue, 12 Nov 2019 11:11:04 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1025B100EBD0;
        Tue, 12 Nov 2019 11:10:57 +0000 (UTC)
Date:   Tue, 12 Nov 2019 19:10:53 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org, hare@suse.com
Subject: Re: [PATCH 6/6] scsi: hisi_sas: Expose multiple hw queues for v3 as
 experimental
Message-ID: <20191112111053.GA31697@ming.t460p>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
 <1571926881-75524-7-git-send-email-john.garry@huawei.com>
 <20191027081910.GB16704@ming.t460p>
 <bd3b09f7-4a51-7cec-49c4-8e2eab3bdfd0@huawei.com>
MIME-Version: 1.0
In-Reply-To: <bd3b09f7-4a51-7cec-49c4-8e2eab3bdfd0@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: vGqH9W-0N8G3pcQ8is3d0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 11, 2019 at 02:02:27PM +0000, John Garry wrote:
> On 27/10/2019 08:19, Ming Lei wrote:
> > >   =09.this_id=09=09=3D -1,
> > > @@ -3265,8 +3300,14 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
> > >   =09shost->max_lun =3D ~0;
> > >   =09shost->max_channel =3D 1;
> > >   =09shost->max_cmd_len =3D 16;
> > > -=09shost->can_queue =3D HISI_SAS_UNRESERVED_IPTT;
> > > -=09shost->cmd_per_lun =3D HISI_SAS_UNRESERVED_IPTT;
> > > +
>=20
> Hi Ming,
>=20
> I mentioned in the thread "blk-mq: improvement on handling IO during CPU
> hotplug" that I was using this series to test that patchset.
>=20
> So just with this patchset (and without yours), I get what looks like som=
e
> IO errors in the LLDD. The error is an underflow error. I can't figure ou=
t
> what is the cause.

Can you post the error log? Or interpret the 'underflow error' from hisi
sas or scsi viewpoint?

>=20
> I'm wondering if the SCSI command is getting corrupted someway.

Why do you think the command is corrupted?

>=20
> > > +=09if (expose_mq_experimental) {
> > > +=09=09shost->can_queue =3D HISI_SAS_MAX_COMMANDS;
> > > +=09=09shost->cmd_per_lun =3D HISI_SAS_MAX_COMMANDS;
> > The above is contradictory with current 'nr_hw_queues''s meaning,
> > see commit on Scsi_Host.nr_hw_queues.
> >=20
>=20
> Right, so I am generating the hostwide tag in the LLDD. And the Scsi
> host-wide host_busy counter should ensure that we don't pump too much IO =
to
> the HBA.

Even without the host-wide host_busy, your approach should work if you
build the hisi sas tag correctly(uniquely), just not efficiently. I'd
suggest you to collect trace and observe if request with expected hisi sas
tag is sent to hardware.

BTW, the patch of 'scsi: core: avoid host-wide host_busy counter for scsi_m=
q'
will be merged to v5.5 if everything is fine.

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3D5.=
5/scsi-queue&id=3D6eb045e092efefafc6687409a6fa6d1dabf0fb69

Thanks,=20
Ming

