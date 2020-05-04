Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDCAC47257
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D5F206EB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgEDG0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 02:26:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:47288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgEDG0T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 May 2020 02:26:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7B41FAE5E;
        Mon,  4 May 2020 06:26:19 +0000 (UTC)
Subject: Re: [PATCH RFC v3 09/41] scsi: use real inquiry data when
 initialising devices
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-10-hare@suse.de> <20200501174907.GF23795@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <173c7a66-c7e5-84fe-347c-fa8582e03ac6@suse.de>
Date:   Mon, 4 May 2020 08:26:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501174907.GF23795@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 7:49 PM, Christoph Hellwig wrote:
> On Thu, Apr 30, 2020 at 03:18:32PM +0200, Hannes Reinecke wrote:
>> Use dummy inquiry data when initialising devices and not just
>> a some string.
> 
> Why?    And what do the values mean?
> 
This is so that we can pass the entire inquiry data to the scsi device, 
pretty much the same way 'normal' scsi devices do.
As for the values they are:

standard INQUIRY: [qualifier indicates no connected LU]
   PQual=1  Device_type=31  RMB=0  LU_CONG=0  version=0x05  [SPC-3]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
     length=36 (0x24), Peripheral device type: no physical device on this lu
  Vendor identification: LINUX
  Product identification: VIRTUALLUN
  Product revision level: 1.0

I'll add a verbose description to the byte string.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
