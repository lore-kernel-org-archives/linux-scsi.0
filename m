Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3127BC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 01:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E5FD206F0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 01:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="br2Yj3TW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNBZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 20:25:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbfKNBZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 20:25:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573694750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjLqkHC9zEQ7RiYwDDBRYIh2FKBXiYCbPENb820XiLU=;
        b=br2Yj3TW1r1dR+oqGJYa4UKWsgXTgZHuvZeATwQ6W1OSIefV9L+HRuCBKVLWEKcqk45R89
        X0SoCd3EzX4rG9Kpwt8tnb7dlnPACwHjNPOpZPz8E/xmuFnvjPuZj0mRq6jiOGqc/qyDzU
        d04ztws+UjoOhfjA2bO+JCG2PnQznZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-4VpFMu1YNYuVp0C7Gak01Q-1; Wed, 13 Nov 2019 20:25:49 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B82141802CE0;
        Thu, 14 Nov 2019 01:25:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1CC61036C69;
        Thu, 14 Nov 2019 01:25:36 +0000 (UTC)
Date:   Thu, 14 Nov 2019 09:25:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>, lkp@lists.01.org
Subject: Re: [scsi] 74eb6c22dc: suspend_stress.fail
Message-ID: <20191114012532.GA14190@ming.t460p>
References: <20191104085021.GF13369@xsang-OptiPlex-9020>
 <824c5a0b-a31a-b0a2-b14a-ab6edd294d07@acm.org>
 <20191105061150.GA17084@ming.t460p>
 <cb814a0c-c636-e9f4-654a-3f21bd0db646@acm.org>
MIME-Version: 1.0
In-Reply-To: <cb814a0c-c636-e9f4-654a-3f21bd0db646@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 4VpFMu1YNYuVp0C7Gak01Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 13, 2019 at 09:00:29AM -0800, Bart Van Assche wrote:
> On 11/4/19 10:11 PM, Ming Lei wrote:
> > On Mon, Nov 04, 2019 at 07:52:59PM -0800, Bart Van Assche wrote:
> > > On 2019-11-04 00:50, kernel test robot wrote:
> > > > FYI, we noticed the following commit (built with gcc-7):
> > > >=20
> > > > commit: 74eb6c22dc70e395b333c9ca579855cd88db8845 ("[RFC PATCH V3 2/=
2] scsi: core: don't limit per-LUN queue depth for SSD")
> > > > url: https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-core-av=
oid-host-wide-host_busy-counter-for-scsi_mq/20191009-015827
> > > > base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git fo=
r-next
> > > >=20
> > > > in testcase: suspend_stress
> > > > with following parameters:
> > > >=20
> > > > =09mode: freeze
> > > > =09iterations: 10
> > >=20
> > > Hi Ming,
> > >=20
> > > This is the second report by the build robot that this patch causes t=
he
> > > suspend_stress test to fail. I assume that that means that that test
> > > failure is not a coincidence. The previous report (Oct-22) is availab=
le
> > > at https://lore.kernel.org/linux-scsi/20191023003027.GD12647@shao2-de=
bian/.
> >=20
> > Yeah, it should be one real issue, and there are other issues too. I wi=
ll work
> > out a new version for addressing all.
>=20
> Hi Ming,
>=20
> Have you already made any progress? I'm asking because the v5.5 merge win=
dow
> is expected to open soon (this weekend).

Hi Bart,

I am busy on other things, and may not have time to look at this issue
for v5.5.

If you have idea for making the patch into mergeable, please go ahead.


thanks,
Ming

