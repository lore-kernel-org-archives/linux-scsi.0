Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59487C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 13:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201C122263
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 13:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="opmOSRGd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1737230AbgJZNNR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:13:17 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56976 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404269AbgJZNMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 09:12:31 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 43F004131A;
        Mon, 26 Oct 2020 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1603717948;
         x=1605532349; bh=/T03XNTjq07IFYLx+eb/uHDkrEwWsSaRhc+ySlfkuuU=; b=
        opmOSRGdJYGCpke2hghvRKNOH4t6sgrsv4T0a4Z0wVeAyKBI1vx/B7q7hAQZxlPh
        ZJqMrwJ67ikgNOhu16XIzWaPxWrYG4tazGcvIUhP5O8gpyoAMgBEuoPPS9poMY6H
        MfF+4trBhgbIKqj7IxQoFTZ7ci8Oc7/KlFP5uzi5FCM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mqm3-bLaFuhx; Mon, 26 Oct 2020 16:12:28 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1D6CE412EB;
        Mon, 26 Oct 2020 16:12:27 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 26
 Oct 2020 16:12:27 +0300
Date:   Mon, 26 Oct 2020 16:12:26 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-ID: <20201026131226.GA88490@SPB-NB-133.local>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 24, 2020 at 05:25:17PM -0700, Bart Van Assche wrote:
> On 10/24/20 5:13 AM, Roman Bolshakov wrote:
> >> Additionally, what benefits does it provide to report a CHECK CONDITION
> >> upon residual overflow?
> > 
> > Typical use case for CHECK CONDITION in case of Underflow/Overflow is
> > extra robustness against buggy initiators [1][2]. Failing both READ and
> > WRITE is the most solid approach in that sense [3][4][5] as it prevents
> > data corruption at all costs.
> > 
> > Suppose an initiator wants to WRITE 8 LBA. For 512-byte formatted LUN,
> > 8 LBAs need a buffer of 4K bytes. For 4096-byte formatted LUN the
> > command would need 32K data buffer.
> > 
> > An Overflow happens if initiator treats 4Kn device like 512n one but
> > provides a buffer of 4K. i.e. to complete the WRITE target needs to
> > consume 28K more data, otherwise only 1 LBA would be written and the
> > rest 7 LBAs would have indeterminate content.
> > 
> > An Underflow happens if initiator confuses 512n device with 4Kn one and
> > provides a buffer of 32K, i.e. target doesn't utilize all buffer for the
> > command.
> 
> Thanks for the additional background information, this really helps. How
> about only rejecting SCSI commands for which the data buffer size is not
> a multiple of the block size? I'm concerned that flagging all SCSI
> commands that have a residue as invalid will break SCSI tape software.
> 

Hi Bart,

Could you please elaborate on how tape software will be broken?
I have no experience with tapes but I've looked into SSC-5 draft.

I haven't found anything concerning the writes but there are tape
variants of overflow/underflow for reads (G.3 General read rules) called
overlength and underlegth, respectively:

  If the read command requests fewer bytes than are available for
  transfer, then the read is an overlength read. If the read requests
  more bytes than are available, then the read is an underlength read.

  The amount of data returned is the smaller of the bytes available and
  the allocation length.

And the next paragraph defines cases where CHECK CONDITION should be
reported for such reads. However, GOOD status is also possible, the next
chapter of the annex (G.4 Examples from figure G.1 using variable-block
transfers and various SILI and BLOCK LENGTH settings) refines many cases
depending on SILI bit, whether block protection is enabled, if the
transfer is FIXED or variable-length and if BLOCK LENGTH is
zero/non-zero.

As far as I understand underlength and overlength are always suppressed
(status is GOOD) for devices where no "default" block size is defined
per SPC (7.5.7.1 General block descriptor format):

  For sequential access devices, a block length of zero indicates that the
  logical block size written to the medium is specified by the TRANSFER
  LENGTH field in the CDB (see SSC-4).

The cases are also summarized in annex D (D.3 Summary of length error
conditions on read type commands).

Note, that if we talk about SSC over FCP, then "9.4.2 FCP_DATA IUs for
read and write operations" does additionally apply. Perhaps a) from
"9.4.2 FCP_DATA IUs for read and write operations" works well for SSC:

  a) process the command normally except that data beyond the FCP_DL count
  shall not be requested or transferred;

The clause allows to accomodate variable-block tranfers from SSC.

So, what if we return CHECK CONDITION only for SBC WRITEs with
residuals?  Then it has no impact on SSC and other device types. In
future, we might also add a patch that would fail SBC READs with
residuals for sake of consistency. That behaviour would be beneficial
for SBC devices as no host could corrupt data or itself by forming,
requesting invalid data buffer.

Thanks,
Roman
