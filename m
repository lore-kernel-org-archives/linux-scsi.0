Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F06AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 05:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF552238D6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 05:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbhAUFYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 00:24:09 -0500
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:40666 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727030AbhAUFQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 00:16:55 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 39D4A182CED2A;
        Thu, 21 Jan 2021 05:15:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: lip23_251530d27560
X-Filterd-Recvd-Size: 1810
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 21 Jan 2021 05:15:45 +0000 (UTC)
Message-ID: <6af62f13816f24cd525865c91892d53483748d0e.camel@perches.com>
Subject: Re: [PATCH v2] scsi/qla4xxx: convert sysfs sprintf/snprintf family
 to sysfs_emit/sysfs_emit_at
From:   Joe Perches <joe@perches.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        njavali@marvell.com
Cc:     mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 20 Jan 2021 21:15:43 -0800
In-Reply-To: <9d745731-f8a3-98bf-3ca8-6367ef53aa8d@acm.org>
References: <1611201437-111938-1-git-send-email-abaci-bugfix@linux.alibaba.com>
         <9d745731-f8a3-98bf-3ca8-6367ef53aa8d@acm.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-20 at 20:55 -0800, Bart Van Assche wrote:
> On 1/20/21 7:57 PM, Jiapeng Zhong wrote:
> > -		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
> > +		return sysfs_emit_at(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
> >  				ha->fw_info.fw_major, ha->fw_info.fw_minor,
> >  				ha->fw_info.fw_patch, ha->fw_info.fw_build);
> 
> From the sysfs_emit_at() source code:
> 
> WARN(... || at >= PAGE_SIZE, "invalid sysfs_emit_at: buf:%p at:%d\n",
> buf, at)
> 
> In other words, this patch is wrong. sysfs_emit() should have been used
> instead of sysfs_emit_at().

Instead, use the cocci script from

commit aa838896d87a ("drivers core: Use sysfs_emit and sysfs_emit_at for
show(device *...) functions")
 


