Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777F3C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Nov 2023 07:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjKHHMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 02:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjKHHMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 02:12:12 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CF01706
        for <linux-scsi@vger.kernel.org>; Tue,  7 Nov 2023 23:12:09 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9dd5879a126so748519766b.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2023 23:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699427528; x=1700032328; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FKhRcXU/n2SpDkdWY6+Pe0hP1oWgQGRbcbbJrl+j5G4=;
        b=r0dRjg0zMSmJpemN0uXWGYODFJGHYndOIWcfkcH487SXU2jKrDHu/a+EgMjYQrm+Ag
         MhX0ugo6AHp0Iko7idNdWw7iqJmP/028IWMU6rfxV98+vndOxMoteUjr+ksdbY5sjQoW
         EpXBzKHZ2KrU43etiII7Y+IgIwf3USBYIYtGUWzmjCxWJhi+6gEqVFb8UsOAfAl6xDPs
         okqUTvUEMQpRVHdEPVxVeaeXBUZ4CYTtac4H2yOayNjKTsyZgygGKiR48JI9w/ypDLZh
         Lq0cJ/wHDtQOlsRiA7d49yJVy0lg91MziZVBLKfhms+5dGY+grKfP02lfD8KP/CsyjTC
         tXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699427528; x=1700032328;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKhRcXU/n2SpDkdWY6+Pe0hP1oWgQGRbcbbJrl+j5G4=;
        b=DLMsedLWxA0yUkzBbe37o/7wm0nVVcRy9DAM8fKlIVJJDcSzi41bWr0fF6OYzoNz1Q
         tRaDBTxD7FSMRHQBsCXIw6GamluvmKQw3foLmQgvXUyeWK/+tXxNXEpjn+DQzhHt5UXd
         /AAHgcIYA8l61XdTP/US09kJmvZ9V2UQEKv0WNxXkD+z0cYyexoD9oszQpxyl4PbuPi+
         l594OU/dbWFtsD2Zkv9WpKQegUeFpicwPkeerwqmK8Xo3B0gCrIMjTJttQeNRL3QfPGc
         vbbzwbfMHJJH5K2oTqMW8+ufh8P+JQFN6Vws8x2YXDIPSAVacSOzPdEE2i01Wa6QU8A2
         KXag==
X-Gm-Message-State: AOJu0YyZund07D3Oig6bx5b+r3+azckerZ1logrvvWkGfBKLYqvjyt4Q
        3gWXbTXm2tfls+2MBgFwT32L0Q==
X-Google-Smtp-Source: AGHT+IFf63FFnNaD0HlDuWsZf0ggJXoRsTIFsOOQMdjEhhRowPaCJO7Nw1jGhRVyRozbzJHJPD9OsQ==
X-Received: by 2002:a17:907:3faa:b0:9be:85c9:43ef with SMTP id hr42-20020a1709073faa00b009be85c943efmr711230ejc.62.1699427528205;
        Tue, 07 Nov 2023 23:12:08 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v25-20020a170906381900b009dfd3b80ba3sm567805ejc.35.2023.11.07.23.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 23:12:07 -0800 (PST)
Date:   Wed, 8 Nov 2023 10:12:05 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Justin Tee <justintee8345@gmail.com>
Cc:     jsmart2021@gmail.com, linux-scsi@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [bug report] scsi: lpfc: Add EDC ELS support
Message-ID: <afd6b1d4-c06a-440d-98b8-ba4defef6cf1@kadam.mountain>
References: <d3e2ffd8-3ebe-4e28-8509-c76f2b991ca3@moroto.mountain>
 <CABPRKS9aAP7ngRkGRxZGggeRQVDJCGA=w_AW+YB+ahiO7TtkUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPRKS9aAP7ngRkGRxZGggeRQVDJCGA=w_AW+YB+ahiO7TtkUQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 07, 2023 at 10:14:40AM -0800, Justin Tee wrote:
> Hi Dan,
> 
> > On Tue, Nov 7, 2023 at 7:26 AM Dan Carpenter <dan.carpenter@linaro.org> wrote:
> > This is a couple years old but apparently, but I've never reported it
> > before.  Smatch wanted a goto try_rdf; here.  Not sure if Smatch is
> > correct.  If not just ignore this it.  These are one time emails.
> 
> I think return –EIO on line 4353 is fine.  If lpfc_nlp_get(ndlp) from
> line 4350 returned NULL, then we want to early return and not issue an
> RDF.  This behavior is consistent with the !ndlp check on lines
> 4307–4308.  If we don’t have a valid ndlp login context with the
> Fabric, then there’s no point to goto try_rdf to issue an RDF.
> 
> And for line 4353, I confirm that the only unwind needed is
> lpfc_els_free_iocb from the previous line.

Thanks, Justin!

regards,
dan carpenter

