Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1693C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 08:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB5020730
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 08:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/06fs1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfKPIzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 03:55:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726257AbfKPIzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Nov 2019 03:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573894503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FOlQsDz4i9gs83FZ9cghflSyGsB1K6vkmV/XRQarwg=;
        b=g/06fs1cRANTnzg0YVsAOoA5LPtW3xwiqL7T85IMWl9KviFGB/EGoFV/aqtOhmqVNoCGyz
        +bASa6l3h+ng61X/xkOYHN4Zpw6tRCakX4ggEAhqeKitIlvGM+9tOB6bCTCbtxccvh6RtV
        /wwj4SuD/wLBdK5GnAve3uUmRKCiAaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-1e1eyZp6OXWFBtX7yvYUqA-1; Sat, 16 Nov 2019 03:55:02 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C2D41852E20;
        Sat, 16 Nov 2019 08:55:00 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65DBB5D6D6;
        Sat, 16 Nov 2019 08:54:48 +0000 (UTC)
Date:   Sat, 16 Nov 2019 16:54:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     linux-scsi@vger.kernel.org,
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
Message-ID: <20191116085443.GA24667@ming.t460p>
References: <20191008100945.24951-3-ming.lei@redhat.com>
 <20191104085021.GF13369@xsang-OptiPlex-9020>
MIME-Version: 1.0
In-Reply-To: <20191104085021.GF13369@xsang-OptiPlex-9020>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 1e1eyZp6OXWFBtX7yvYUqA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Oliver,

On Mon, Nov 04, 2019 at 04:50:21PM +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
>=20
> commit: 74eb6c22dc70e395b333c9ca579855cd88db8845 ("[RFC PATCH V3 2/2] scs=
i: core: don't limit per-LUN queue depth for SSD")
> url: https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-core-avoid-ho=
st-wide-host_busy-counter-for-scsi_mq/20191009-015827
> base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
>=20
> in testcase: suspend_stress
> with following parameters:
>=20
> =09mode: freeze
> =09iterations: 10
>=20
>=20
>=20
> on test machine: 4 threads Skylake with 8G memory
>=20
> caused below changes (please refer to attached dmesg/kmsg for entire log/=
backtrace):
>=20
>=20
>=20
>=20
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>=20
> test started
>=20
> (then just like hang)
> (below is what looks like if test can pass
> SUSPEND RESUME TEST STARTED
> Suspend to freeze 1/10:
> ...
> Done
> Sleep for 10 seconds
> Suspend to freeze 2/10:
> ...
> Suspend to freeze 10/10:
> ...
> Sleep for 10 seconds
> SUSPEND RESUME TEST SUCCESS)

From the dmesg via 'zcat kmsg.xz', looks there isn't any failure found.
'Suspend to freeze' has run successfully 10 times, and finally the
message of 'SUSPEND RESUME TEST SUCCESS' does show in the log.

Could you double check if it is a valid report?

Thanks,
Ming

