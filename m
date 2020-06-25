Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB032C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 19:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D7F20679
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 19:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVKEq8uh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406441AbgFYTBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 15:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406409AbgFYTBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 15:01:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4868C08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 12:01:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f23so7260087iof.6
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 12:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MqGibfe7wiuAHLMRoT7h4FQe2Tr97ItfXMWDUJHJ8UU=;
        b=aVKEq8uhbC/r4LSwNroUP+VmtYcxkdHaj9Ftm2jao9O3gratgAHhcinI+Aqle15QVl
         M4FMnreIE4Q8eAfSfvvGUzad+rkpjYTa4hApfrf4TA0oeOKLE9RSJWUiooSr4R14m8Dk
         rV+S11xJtAnFyjPmfUOeZCUd4KXV7JntA2I5z7KPF+Aw5RZlLt7BOzCyU0VLKzoS+fBv
         XgpiDzldEc6lZv+kzmW2mXatYD6G+nha1cUWvNRIpK/2mGALqjMjUzHoCMbUzklJ1TE/
         g7Fgl/4jFbfDi6E7UyBWxN5oqN2L7lrHjGDsVZ+B/YySqLyKcLsUk5r0t9jQHMq86/xH
         JQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MqGibfe7wiuAHLMRoT7h4FQe2Tr97ItfXMWDUJHJ8UU=;
        b=JYRVf6o9s3J/Akxd1OcigekxL38gA1rSNrMR32HbkJ7OztiE4Ky2OE76vV4Ocl+OFU
         aIRx37UUS7dGVU/x+N5PDf+dcnnMV86v+TpA/ArJsEzJAz5lfbz2zyX2fUMeSIEGh8zX
         OnSUqjfBvc9KfAergbKXxo6kPxhqLG2gTLWsfQqKwJSCHi7ax3s6i2w0KDjk6s/G05Au
         BAoDJ2im00trfI1Id3gAa+sgA0cNeOS1apE1EQrI2nKjPiU3607WH2RLCmEDmHsUcG8m
         FnkvPvG5jmW9eIiGQ9nwEnIJpYbbDmZp5MCllrKzXFwdSNu4jsa174st6zj9vXSsS8La
         QzlA==
X-Gm-Message-State: AOAM5314GPAvYLK74VNOIxVrpkVRD/Bp8DRsz8HZ9niBEh/oSx8j8tov
        zdHvndWV/KAXQvQY5848dkS30bve8+j0tVNyMnAyRw1w
X-Google-Smtp-Source: ABdhPJyrVO4nznnvGPb0PjW7ViEMdDuALq+Z38oOKa+BNzE+1itTbkyxUewCTjqSdqTP+AC27M9A+LidftnqczfCbvQ=
X-Received: by 2002:a5e:9703:: with SMTP id w3mr32331163ioj.29.1593111698757;
 Thu, 25 Jun 2020 12:01:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5e:8b07:0:0:0:0:0 with HTTP; Thu, 25 Jun 2020 12:01:38
 -0700 (PDT)
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 25 Jun 2020 21:01:38 +0200
Message-ID: <CAKR_QVKaRMshWKGEhLpRK40yix1UP1ZMaoDJPBHFBdazc7L0cA@mail.gmail.com>
Subject: ufs-bsg node not created
To:     linux-scsi@vger.kernel.org
Cc:     beanhuo@micron.com, avri.altman@wdc.com, cang@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

I'm trying to use the ufs-bsg transport for SSD debug tool and facing
an issue where there is no ufs-bsg node created either in /dev or
/dev/bsg.

Tried on live Ubuntu 20.04, and Ubuntu 16.04.6 installation with
custom built kernel 5.6.14.
Additionaly, tried rebuilding with [PATCH v2 0/3] Modulize ufs-bsg
series, I can modprobe ufs-bsg, ufs, bsg modules, still no ufs-bsg
node gets created.

Is there some other module that needs to get loaded?

Thanks, Tom
