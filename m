Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE882E11C1
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 05:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750052068; cv=none; b=UYa0wKZaZyfNpIGyd4awftvgM7ejwn5TD9kE/UDQ1FEs7XedcvswCcxRnKKeBlBP9MDgi35isgGZme9VFVzKYOtFB2bUGX/pYcONvZ+nODdxFtD2TJxpJUspuE+H3TMkPD6ZGHWzN1fFngf0Puj9kO/vzYgV7VJarzKKyZdA5Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750052068; c=relaxed/simple;
	bh=0sM/aZNCERc6KuhLn844dszptkPFUnllX3CUSFR9SvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UoyINhjEFaWSrsF/GWP8/wjzlXvvm7OJKxs/a/zMBeSARyOWvYXQNLWk3dS1Mb4lMbDvRAN8deDB/2BBpzeLhb9SCL7qfPuQft+m1Z7TxSC/2gnoT2KG1AroCKMvLvDqXaAcTemBlk0HwcD302PVVfnWwtbUVuv27QZfSrX409o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tvj/jBL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tvj/jBL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6301FC4CEF1;
	Mon, 16 Jun 2025 05:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750052067;
	bh=0sM/aZNCERc6KuhLn844dszptkPFUnllX3CUSFR9SvY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Tvj/jBL8vQbcaSIlN4k4Po3lHN6NQUt28fqt5J9TqVQbnvTPq3E/AdlP9RIOVssYw
	 1UcjVwWVACT0iytgrUPijF97FeOojOWEMB0FQ3rR/6MDoNt5U7XTFla8oKGU5MAhte
	 hYT/6eLzaB5SMTNxfQMfsEmiXfqXYmiPeNMArgxGx6HZgevdJp2LJcjn0Rj7ulKEzZ
	 FJYb6G1q0c4fXdeyu77mwzfrGy/NEYWFLqBG/8tMxmaq7F8Jkv/h3oof65Z6lHa96a
	 jP/pf8pTxdEtX6OGEonCmtIiIpxAv0uyD/7LT75AgXZ1dbGFZNhbJOLJU+71mNR2AU
	 6EmaIvk/8xP3A==
Message-ID: <690b0726-f183-4ec7-91fa-ad3c706ba2bc@kernel.org>
Date: Mon, 16 Jun 2025 14:34:26 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: sd: Set a default optimal IO size if one is
 not defined
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250613062909.2505759-1-dlemoal@kernel.org>
 <20250613062909.2505759-3-dlemoal@kernel.org>
 <b20bde78-5f11-4700-9f99-e9bf4bc31e85@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b20bde78-5f11-4700-9f99-e9bf4bc31e85@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/13/25 23:31, John Garry wrote:
> On 13/06/2025 07:29, Damien Le Moal wrote:
>> Introduce the helper function sd_set_io_opt() to set a disk io_opt
>> limit. This new way of setting this limit falls back to using the
>> max_sectors limit if the host does not define an optimal sector limit
>> and the device did not indicate an optimal transfer size (e.g. as is
>> the case for ATA devices). io_opt calculation is done using a local
>> 64-bits variable to avoid overflows. The final value is clamped to
>> UINT_MAX aligned down to the device physical block size.
>>
>> This fallback io_opt limit avoids setting up the disk with a zero
>> io_opt limit, which result in the rather small 128 KB read_ahead_kb
>> attribute. The larger read_ahead_kb value set with the default non-zero
>> io_opt limit significantly improves buffered read performance with file
>> systems without any intervention from the user.
> 
> Out of curiosity, why do this just for sd.c and not always set up the 
> default like this in blk_validate_limits()?

Good point. Though I think we do not want to have a large io_opt for slow
devices like MMC/SD Cards. So something like this, which is indeed simpler than
hacking lim->io_opt in sd.c.

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..d3ec6f4100f4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -58,16 +58,24 @@ EXPORT_SYMBOL(blk_set_stacking_limits);
 void blk_apply_bdi_limits(struct backing_dev_info *bdi,
                struct queue_limits *lim)
 {
+       u64 io_opt = lim->io_opt;
+
        /*
         * For read-ahead of large files to be effective, we need to read ahead
-        * at least twice the optimal I/O size.
+        * at least twice the optimal I/O size. For rotational devices that do
+        * not report an optimal I/O size (e.g. ATA HDDs), use the maximum I/O
+        * size to avoid falling back to the (rather inefficient) small default
+        * read-ahead size.
         *
         * There is no hardware limitation for the read-ahead size and the user
         * might have increased the read-ahead size through sysfs, so don't ever
         * decrease it.
         */
+       if (!io_opt && (lim->features & BLK_FEAT_ROTATIONAL))
+               io_opt = lim->max_sectors;
+
        bdi->ra_pages = max3(bdi->ra_pages,
-                               lim->io_opt * 2 / PAGE_SIZE,
+                               io_opt * 2 >> PAGE_SHIFT,
                                VM_READAHEAD_PAGES);
        bdi->io_pages = lim->max_sectors >> PAGE_SECTORS_SHIFT;
 }

I will make a proper patch of this and send it out as a replacement.

-- 
Damien Le Moal
Western Digital Research
