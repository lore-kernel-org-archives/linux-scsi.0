Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B12AC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 09:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D9B20724
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 09:19:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="au3J6bdV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgF1JTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 05:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgF1JTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 05:19:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C86C061794
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2020 02:19:03 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i4so14077913iov.11
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2020 02:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dW/2t4TGrHfqrhLgODfFGEWXYiT6XSNFiipUQzG/5wQ=;
        b=au3J6bdVtYOguBaAkuUK9HPOQxjaib95ywCDiYO8PB8Qmo2f4bu7NurqBgO6U6hWqc
         QyD6PLmnBLmvbDNh09nI5bogHSD+66BNNBjqU+dTAXDDYnhBaZC8VU813N495dkH/MDD
         ze4ztDOx2P95Ccwj7obUU8DOg4wj48sGjBOIqIf23W+EgfoU2a5PB7S/wtiKTOBMrk0l
         Gpn8MqX6GGoB9VQdzgzK4l1lJeV8VtZKhY4u4Ropqy3Nu6yDHHWHL0OB/HBZ9Bcmccof
         hqR3smdH3zIhUF4zXeL4lVeFuE+25+6bToxpO7i6pnLpm0PcLYaA2EuorsXPR6GNVnoy
         Qs5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=dW/2t4TGrHfqrhLgODfFGEWXYiT6XSNFiipUQzG/5wQ=;
        b=Y9gMztIrtJ8iNpDpC919c7i1jv8cAzvuy6dFhKyQxfWuLSbWjmt/9nCfEpdqlJhv+v
         BRBtN6C1bRrnBi9HOffwl5mJxb8SNN+xyW3I4kD87CunNzhNh4vmPPs51l/dRNwuAdxz
         l9Z4CEKabItQSu2X8KeKhdbLUTWFjxd2FJaWsYmrMzGqVwpYgM7vgG4s3B+lGY1tN3+U
         krfAbyLiWo6XdNB6STlL/Lw5akRkIdEQWFdl+sFCEhVSjFPuGF7dS68/OmgAIm1Dn0kx
         hv3oHc8AgEtu4Xf9Z5GNm39dj1ovu+YyVvDvm3A4KAF7nZhRo0vhF+4DqJioV+LA7Y0Y
         ewQg==
X-Gm-Message-State: AOAM531C/O8K5hn3ziv371ZeqqvpPh8gqNJNsYV//5SlAJjGPbRP9xNd
        Je+X5l6qknN6TQfCde8Msh4oOthVIdWuRxs230g=
X-Google-Smtp-Source: ABdhPJx9jYrlK1sOsTqkbOQcpFe6Ij+S5VUQsqiNuJfkoyvCC18tMHHrBxPKDnc55XAS3feDnVrtyrfePUDfdg2dqss=
X-Received: by 2002:a6b:9042:: with SMTP id s63mr11910778iod.195.1593335942709;
 Sun, 28 Jun 2020 02:19:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5e:8b07:0:0:0:0:0 with HTTP; Sun, 28 Jun 2020 02:19:02
 -0700 (PDT)
In-Reply-To: <SN6PR04MB46402B987856A3A8472106A0FC910@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CAKR_QVKaRMshWKGEhLpRK40yix1UP1ZMaoDJPBHFBdazc7L0cA@mail.gmail.com>
 <SN6PR04MB46402B987856A3A8472106A0FC910@SN6PR04MB4640.namprd04.prod.outlook.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sun, 28 Jun 2020 11:19:02 +0200
Message-ID: <CAKR_QVJBic2HLHY1YCYkLW7rOwgcdBHTM-YKAjp=NDX8q1uopw@mail.gmail.com>
Subject: Re: ufs-bsg node not created
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/06/2020, Avri Altman <Avri.Altman@wdc.com> wrote:
> Hi Tom,
>
>>
>> Hi
>>
>> I'm trying to use the ufs-bsg transport for SSD debug tool and facing
>> an issue where there is no ufs-bsg node created either in /dev or
>> /dev/bsg.
> ufs-bsg is a bsg node designed to communicate with a ufs devices,
> using non-scsi commands, but a ufs-specific protocol, which your ssd doesn't
> speak.
> So you can't use it with any non-ufs devices.
> To create it you need to open its config switch - CONFIG_SCSI_UFS_BSG.
>
> Maybe try using the sg driver?
>
> Thanks,
> Avri
>
>

CONFIG_BLK_DEV_BSG, CONFIG_BLK_DEV_BSGLIB, CONFIG_SCSI_UFS_BSG were
already enabled.
Issuing a firmware info command but passing /dev/sda as a node
returned expected result, so the drive is at least partially supported
by the tool.
Anyway, after inspection of the drive with DMM the point of failure
appears to be at hardware level so the tool won't be much of a use.
It's Micron M600 m2 disk btw.

Thanks, Tom
