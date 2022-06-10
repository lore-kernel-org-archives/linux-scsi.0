Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634E6C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 14:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbiFJOsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 10:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349684AbiFJOr5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 10:47:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A1B712D8;
        Fri, 10 Jun 2022 07:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B96AB8360F;
        Fri, 10 Jun 2022 14:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0CDC34114;
        Fri, 10 Jun 2022 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654872459;
        bh=1G/kKmnPuQ1+bfxE++tWRK/QGRB9Ib5YyobZ1xQvME0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NiinhiVfxa3+BNyJJbeXiwbniXz/YHopf92NhbJtOQtFSK+B/p4Hxv3EXkryys/j2
         VLQvB2G1Oysi77kecifFhRPz7qKlcPslRapbJgUDEcCHXWqUuSzuSL4/w5lIIeI/RB
         LdBI8tzU3HFJ7jHdntGsOqwJcv8kVFG4Mn0IBYySqGOrSlaPwMM9hE+Ri+OzWsAdag
         sbmw7wcBwB+xmYDscdX1Aasox5fBEsSRuTdIiIekly8r3vkmGytMPZ7WU5p2lEjwsL
         LXcw0nIzS35MNtI0PXsQCxIzD0kOtPLRF7SGskKBkIlC/Iw2WCpF3Qu++iV6xKp/Zw
         Zbagt/xnpSadw==
Date:   Fri, 10 Jun 2022 08:47:36 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v5.19-rc1
Message-ID: <YqNZiMw+rH5gyZDI@kbusch-mbp.dhcp.thefacebook.com>
References: <20220609235329.4jbz4wr3eg2nmzqa@shindev>
 <717734c9-c633-fb48-499e-7e3e15113020@nvidia.com>
 <19d09611-42cc-5a81-d676-c5375865c14c@nvidia.com>
 <20220610122517.6pt5y63hcosk5mes@shindev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610122517.6pt5y63hcosk5mes@shindev>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 10, 2022 at 12:25:17PM +0000, Shinichiro Kawasaki wrote:
> On Jun 10, 2022 / 09:32, Chaitanya Kulkarni wrote:
> > >> #6: nvme/032: Failed at the first run after system reboot.
> > >>                 Used QEMU NVME device as TEST_DEV.
> > >>
> > 
> > ofcourse we need to fix this issue but can you also
> > try it with the real H/W ?
> 
> Hi Chaitanya, thank you for looking into the failures. I have just run the test
> case nvme/032 with real NVME device and observed the exactly same symptom as
> QEMU NVME device.

QEMU is perfectly fine for this test. There's no need to bring in "real"
hardware for this.

And I am not even sure this is real. I don't know yet why this is showing up
only now, but this should fix it:

---
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fc804e08e3cb..bebd816c11e6 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -476,7 +476,7 @@ static ssize_t dev_rescan_store(struct device *dev,
 	}
 	return count;
 }
-static struct device_attribute dev_attr_dev_rescan = __ATTR(rescan, 0200, NULL,
+static struct device_attribute dev_attr_dev_rescan = __ATTR_IGNORE_LOCKDEP(rescan, 0200, NULL,
 							    dev_rescan_store);
 
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
--
