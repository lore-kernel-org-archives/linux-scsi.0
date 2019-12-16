Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E51C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 18:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F622082E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 18:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAA97LcK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfLPSo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 13:44:56 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40363 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbfLPSoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 13:44:55 -0500
Received: by mail-pf1-f193.google.com with SMTP id q8so6071973pfh.7;
        Mon, 16 Dec 2019 10:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=565fc6trZy4bzYebyeRmDvS9Y4aKY1nHDQfb3rsmedc=;
        b=AAA97LcKasXFutNj5F1JGuGjWcAsQtLV8CuOAdqhawOKa6Ix8fu+Ra+L7Ns88YBaS9
         15VMHT0pMQ8aLnrW7bHTZeUq5/Ky5t93EpLesvGEqlvtuQ0JQdSc8XLgMxQACs8sbP14
         8EEV8Cx4zfpN7sd/YOLiGxlNEg+nTKXU30AAJfDy1f3Z3rHwM3griO2thdqdVtGa1R+x
         D6P8lStO/sZvl8hUkjKsMkH2Tg0JRKY2dGURD/cfhUjsEMJ6r3ezDxDvXUDk0cHyshsN
         gtABy7blMfJMJfkipxFDafTe+L0n3ViO/h8sh+tEgihKxLxxh1C0F77i3ciXwsbks5qV
         DmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=565fc6trZy4bzYebyeRmDvS9Y4aKY1nHDQfb3rsmedc=;
        b=eNYXtsrWa+FFn5xIMk1NxB1kPeYkHGbY+/cWi4htj3kalK+uY69wlJRqzvScNn4her
         nTzut7eD82sS1c4Bjlqyzi4c3CwLO39Uy/Ay/cLMwZsaLjJn/L4BfFAPGeeFJ1g4ssIF
         1Qb6u4J9aa0CTvRMUN/oXrnqoCkwPs6hnSvv8EqPq84zkOukIjE+9yIfTVyiIa0BWWyr
         sAf0Vuc2tHtxnlti/SZq4mLTb6m3Cw2jTSuvHt5u+FoxJ+nugdDB8dQ3wAMKGfRN4QCV
         c3IP1gwkcUrBm6yQR2aQhajy9dBDkKGKqxYe1Dd4Ud3HUYJNHIuYQRmUhZeDlRV2tnDX
         XCFQ==
X-Gm-Message-State: APjAAAXZacM7Hpl+NcUIiFklPTvfbUH5QTRVFB/pDJkpn4tUZsoqWh6p
        fgSX8zeGz0QI3zx6pB+slV/S6NOz
X-Google-Smtp-Source: APXvYqxihnLNPEcDTkUZq/Nw6sBPnbaVIkoTnU+2z38SN+fG3whW1DDIt5Qe51JlPLBUKdW9k9t2Wg==
X-Received: by 2002:a62:ed19:: with SMTP id u25mr17938033pfh.173.1576521894681;
        Mon, 16 Dec 2019 10:44:54 -0800 (PST)
Received: from [10.69.49.110] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a26sm23650190pfo.5.2019.12.16.10.44.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Dec 2019 10:44:53 -0800 (PST)
Subject: Re: [PATCH] scsi: lpfc: fix build failure with DEBUGFS disabled
To:     Arnd Bergmann <arnd@arndb.de>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191216131701.3125077-1-arnd@arndb.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <459ba3b4-8f8e-1eb1-a9d2-fb1f866db600@gmail.com>
Date:   Mon, 16 Dec 2019 10:44:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191216131701.3125077-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/2019 5:16 AM, Arnd Bergmann wrote:
> A recent change appears to have moved an #endif by accident:
> 
> drivers/scsi/lpfc/lpfc_debugfs.c:5393:18: error: 'lpfc_debugfs_dumpHBASlim_open' undeclared here (not in a function); did you mean 'lpfc_debugfs_op_dumpHBASlim'?
> drivers/scsi/lpfc/lpfc_debugfs.c:5394:18: error: 'lpfc_debugfs_lseek' undeclared here (not in a function); did you mean 'lpfc_debugfs_nvme_trc'?
> drivers/scsi/lpfc/lpfc_debugfs.c:5395:18: error: 'lpfc_debugfs_read' undeclared here (not in a function); did you mean 'lpfc_debug_dump_q'?
> drivers/scsi/lpfc/lpfc_debugfs.c:5396:18: error: 'lpfc_debugfs_release' undeclared here (not in a function); did you mean 'lpfc_debugfs_terminate'?
> drivers/scsi/lpfc/lpfc_debugfs.c:5402:18: error: 'lpfc_debugfs_dumpHostSlim_open' undeclared here (not in a function); did you mean 'lpfc_debugfs_op_dumpHostSlim'?
> 
> Move it back to where it was previously.
> 
> Fixes: 95bfc6d8ad86 ("scsi: lpfc: Make FW logging dynamically configurable")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thank You

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

