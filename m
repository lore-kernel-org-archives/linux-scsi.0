Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0761C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 07:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9319C2089D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 07:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2R2S9W1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKUHgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:36:53 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbfKUHgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 02:36:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574321812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMLXbpuWfjelMOgdLnQrPhFZs6+Rjsf04guZ/isRNyE=;
        b=c2R2S9W101Ka1KY5qIK0F5RceGOUhBrAHOifo2zOizRIzjjLc2oXNbQEM31UyIOYW09OaA
        KdGXiA2xLFicaPO8ilosSxTdo6mmv/K3G2CPfjKUWQWwtoRdIrFqZ2+2v4y7MmtLZPaPbJ
        nIawIYCR4YJtYtSM1NbpNc/BOo/V1Pc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-P4rbAeJcMji9j44UvKQLSQ-1; Thu, 21 Nov 2019 02:36:51 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86ACC107ACC4;
        Thu, 21 Nov 2019 07:36:48 +0000 (UTC)
Received: from ming.t460p (ovpn-8-33.pek2.redhat.com [10.72.8.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66DEA6CE5D;
        Thu, 21 Nov 2019 07:36:38 +0000 (UTC)
Date:   Thu, 21 Nov 2019 15:36:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Oliver Sang <oliver.sang@intel.com>
Cc:     "Zhang, Rui" <rui.zhang@intel.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>, lkp@lists.01.org
Subject: Re: [scsi]  74eb6c22dc: suspend_stress.fail
Message-ID: <20191121073634.GA4755@ming.t460p>
References: <20191008100945.24951-3-ming.lei@redhat.com>
 <20191104085021.GF13369@xsang-OptiPlex-9020>
 <20191116085443.GA24667@ming.t460p>
 <20191121065000.GA9619@xsang-OptiPlex-9020>
MIME-Version: 1.0
In-Reply-To: <20191121065000.GA9619@xsang-OptiPlex-9020>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: P4rbAeJcMji9j44UvKQLSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 21, 2019 at 02:50:00PM +0800, Oliver Sang wrote:
> On Sat, Nov 16, 2019 at 04:54:43PM +0800, Ming Lei wrote:
> > Hello Oliver,
> >=20
> > On Mon, Nov 04, 2019 at 04:50:21PM +0800, kernel test robot wrote:
> > > FYI, we noticed the following commit (built with gcc-7):
> > >=20
> > > commit: 74eb6c22dc70e395b333c9ca579855cd88db8845 ("[RFC PATCH V3 2/2]=
 scsi: core: don't limit per-LUN queue depth for SSD")
> > > url: https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-core-avoi=
d-host-wide-host_busy-counter-for-scsi_mq/20191009-015827
> > > base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-=
next
> > >=20
> > > in testcase: suspend_stress
> > > with following parameters:
> > >=20
> > > =09mode: freeze
> > > =09iterations: 10
> > >=20
> > >=20
> > >=20
> > > on test machine: 4 threads Skylake with 8G memory
> > >=20
> > > caused below changes (please refer to attached dmesg/kmsg for entire =
log/backtrace):
> > >=20
> > >=20
> > >=20
> > >=20
> > > If you fix the issue, kindly add following tag
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > >=20
> > > test started
> > >=20
> > > (then just like hang)
> > > (below is what looks like if test can pass
> > > SUSPEND RESUME TEST STARTED
> > > Suspend to freeze 1/10:
> > > ...
> > > Done
> > > Sleep for 10 seconds
> > > Suspend to freeze 2/10:
> > > ...
> > > Suspend to freeze 10/10:
> > > ...
> > > Sleep for 10 seconds
> > > SUSPEND RESUME TEST SUCCESS)
> >=20
> > From the dmesg via 'zcat kmsg.xz', looks there isn't any failure found.
> > 'Suspend to freeze' has run successfully 10 times, and finally the
> > message of 'SUSPEND RESUME TEST SUCCESS' does show in the log.
> >=20
> > Could you double check if it is a valid report?
>=20
> Hi Ming, sorry for confusion. this case didn't always fail in our tests, =
and unfortunately,
> due to some code problem, the kmsg.xz attached in the original mail is fr=
om PASS test.
> (In failed tests, we cannot generate the kmsg so far actually)
>=20
> However, in our tests, the regression is clear, for parent commit, the te=
st all passed,
> for this commit, the tests are easy to fail.
> 69fdd747ae1fa088  74eb6c22dc70e395b333c9ca57 =20
> ----------------  -------------------------- =20
>            :18          50%           9:18    suspend_stress.fail
>=20
> @Rui also helped double confirm the regression by another power test - an=
alyze_suspend, which
> also shows this clear regression. Rui maybe could supply more information=
. Thanks!

OK.

Now I have posted the following new patchset, and this one has been
obsolete, so please drop it in your tree, then test new patches
and see if the failure can be reproduced. If yes, post us the dmesg
log.

https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redhat.com=
/T/#t

Thanks,
Ming

