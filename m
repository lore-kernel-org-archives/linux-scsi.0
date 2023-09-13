Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F82EE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjIMBsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbjIMBsx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:48:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DB810DF;
        Tue, 12 Sep 2023 18:48:49 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bf1935f6c2so3410605ad.1;
        Tue, 12 Sep 2023 18:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569729; x=1695174529; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vU1RzpKjikkZlCtHp/CQMirDkGOs43AZ608zTi9r4NA=;
        b=XlHFZUZFhvd6vJyTeiLyIdkEj1Nkgiy8oGxETaxqV4cFxk+1xbiptnsFToTCyGHI7k
         K0Lz+75qADKT2znHQcHzSIS/f1PBH24LCeYGI1oNS3A6H1DnsY4YUcZ0yqOsYRXuaXol
         t7xvQCClVN6oEcov4Amxn/dcKNxV3KBL548fS6qNBXDw9/GDu27YgDKcinw4nOqvrIEn
         ct44vyfPzWVsToR6hq8iVnwhgbI4dD8AiAu2BKvhn+CxBgy0qjtkPBmhD9f+Du+eTtUC
         xctLHPZe0ykxivXAP5vEyl79ka4ybwo+j1555eMnBKzz1djOg5kqtqA0Q7xNid9NAQ+6
         F/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569729; x=1695174529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vU1RzpKjikkZlCtHp/CQMirDkGOs43AZ608zTi9r4NA=;
        b=OBfRD7sQRjoWxLuxPXLWSEIm2GlLvW5bSPjctYVQ6R7uc2tM/d1wX4qoHPOAVJWTNR
         Se5TgJNgmYW7+gObJOtGWfKcYNzqxQNAU736ujIxVIsEcWnvbQxgkjnlxeixsuWa0/TD
         FlTTwRUXNBfVrq94ahNRfJE960PTOuddwMZS/bLmrpVmClx8igd8Y8xEDxL8x/SW4nsq
         JFFTlYAXcTRTw2ZfRrk6/6p8KkTQymLPdW4UV2jkHJbwvJ19uFUj700nRVRqpZLHnDop
         jROy6ZSwR5vw0K5H3DW3fLL3w2rDt6gqeYY4bIRrfgn+HWbW1YnOg/H8qVBMHKcb8kVA
         mfQw==
X-Gm-Message-State: AOJu0YxjazVIZCmSxVotWI5KaHZWAUos8qms9//fnfdPlucehaUfoPXI
        4wIUBtYbdw9COxCei6pb/ipwPMjO42EH2g==
X-Google-Smtp-Source: AGHT+IFc5tLSbzJJlhuiw1uWJOBeTGwLyfU20XTBwvYPCFVrpt+ekJz1C71NdCGSclqyX0HJkDk/DQ==
X-Received: by 2002:a17:903:11d1:b0:1c0:ce0f:ab57 with SMTP id q17-20020a17090311d100b001c0ce0fab57mr2052453plh.3.1694569729217;
        Tue, 12 Sep 2023 18:48:49 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id g24-20020a1709029f9800b001b8c6662094sm8652629plq.188.2023.09.12.18.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:48:48 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:48:43 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 16/19] ata: libata-sata: Improve ata_sas_slave_configure()
Message-ID: <ZQEU+9U2mcUuOx8W@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-17-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-17-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:14PM +0900, Damien Le Moal wrote:
> Change ata_sas_slave_configure() to return the return value of
> ata_scsi_dev_config() to ensure that any error from that function is
> propagated to libsas.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
