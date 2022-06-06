Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B72BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jun 2022 10:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiFFKY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiFFKY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2022 06:24:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFF11D315
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 03:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654511065; x=1686047065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nBGhhEbBFxVusIpBEHH8++r1sfJROZ0nXUk9EhiNcmY=;
  b=ThPto13iatuXVr9PoRJ/rjhHbRc4O1h1R23jjDzBYlevu6ODyqNvKhEs
   UVajejh/ALCWjz5ncIWcegOKich++KbKlcCp03VF/3fDet+XQdIvceQnO
   QXUYnVcePrUz/TGk6+tQakO+Bzp5WLtK0ZPmy9LUWlxJZ8MFopzCrCKWn
   GmcJyIvW+hH6pqTAJ6sZPUYLvwyUORTOCMNlXtq/egh6w6GHQxqqXXkeB
   nSZ7LVsl92YICY4rMmtUWr/7ERQibiQJOfp1NqTBW0ASTSM377uSGSz/G
   y5G7oOoysphaEQlgBdS2QNnB480UPScEGUhtuxqlTfdg24G2jtJG3trYa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="362987992"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="362987992"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 03:24:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="669426991"
Received: from apaszkie-desk.igk.intel.com (HELO [10.102.102.225]) ([10.102.102.225])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2022 03:24:23 -0700
Message-ID: <c15b98e3-f1e5-79c9-3581-6b015b476cad@intel.com>
Date:   Mon, 6 Jun 2022 12:24:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH 05/10] scsi/isci: Replace completion_tasklet with threaded
 irq
Content-Language: en-US
To:     Davidlohr Bueso <dave@stgolabs.net>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-6-dave@stgolabs.net>
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
In-Reply-To: <20220530231512.9729-6-dave@stgolabs.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31.05.2022 01:15, Davidlohr Bueso wrote:
> Tasklets have long been deprecated as being too heavy on the system
> by running in irq context - and this is not a performance critical
> path. If a higher priority process wants to run, it must wait for
> the tasklet to finish before doing so. A more suitable equivalent
> is to converted to threaded irq instead and run in regular task
> context.
> 
> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
