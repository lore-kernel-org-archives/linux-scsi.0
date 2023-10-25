Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E14DC25B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 21:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjJYVao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjJYVaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 17:30:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12958136;
        Wed, 25 Oct 2023 14:30:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2451AC433C9;
        Wed, 25 Oct 2023 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698269437;
        bh=66MePfRdc6SABrOeiEujR/EtFFZY+zATBk+oVCpEqnk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=GDRom8vC8jVmES6UqKH7kfEhx1nuCTK5PdG2dqGHoC9yVEzq5XzEQ+KLTumljzb1o
         Fu0teQzcVbMx1IZjZnG1ulZQsAAyH7r7k2pei0VwcWegqej51s15b8uZMnYaC/y5KD
         dWv6Wx6+vYqsnhWhhCUah1Co27hKwa/C+oD3DofKTy7yyE7aJtOvE6HmRAeH7hsLsQ
         GJfOOP2Av7FVUlhZXOhSjqobc1V0K+9bnvE4XwABEDbXpJ+9mcebXQMxAzGzXFUJv0
         gfFXh1LqQJptxQNLTLgPx+fRz4brZMwTuICT0oPeYo8A2cu/x2g8f0MW6enu0Ww76L
         0y+gFaBoihBwg==
Message-ID: <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
Date:   Thu, 26 Oct 2023 06:30:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
Content-Language: en-US
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231025070117.464903-1-dlemoal@kernel.org>
 <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 20:57, James Bottomley wrote:
> On Wed, 2023-10-25 at 16:01 +0900, Damien Le Moal wrote:
>> +++ b/include/scsi/scsi_device.h
>> @@ -164,6 +164,7 @@ struct scsi_device {
>>  
>>         bool manage_system_start_stop; /* Let HLD (sd) manage system
>> start/stop */
>>         bool manage_runtime_start_stop; /* Let HLD (sd) manage
>> runtime start/stop */
>> +       bool manage_shutdown;   /* Let HLD (sd) manage shutdown */
>>  
> 
> I think at least 85% of the world gets confused about the difference
> between runtime/system start/stop and shutdown.  Could we at least
> point to a doc explaining it in a comment here?

Would improving the comments here be enough ? E.g. something like:

	/* Let the HLD (sd) manage system suspend (start) and resume (stop).
	 * This applies to both suspend to RAM and suspend to disk
	 * (hybernation).
	 */
	bool manage_system_start_stop;

	/*
	 * Let the HLD (sd) manage device runtime suspend (stop) and
	 * resume (start).
	 */
	bool manage_runtime_start_stop;

	/* Let the HLD (sd) manage system power-off (shutdown) */
	bool manage_shutdown;


-- 
Damien Le Moal
Western Digital Research

