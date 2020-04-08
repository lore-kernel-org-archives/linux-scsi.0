Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CE8C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 05:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C069E206C0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 05:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aeoncomputing-com.20150623.gappssmtp.com header.i=@aeoncomputing-com.20150623.gappssmtp.com header.b="Id053QxN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgDHFPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 01:15:41 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:36985 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgDHFPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 01:15:41 -0400
Received: by mail-ot1-f46.google.com with SMTP id g23so5618522otq.4
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 22:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aeoncomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fv8vyZIK5GEhBqzh5VZZkAmXzg5nvfAHE/JoOZfWhqE=;
        b=Id053QxNZrBgx6SPUN1JAVaNMf03kcIX4OxY/PnWccCotaWefEjHf43xPAbM8uFN7T
         rgkaBCpWRJu/e8KI4deVVGmfaPkIjN4cwLQ5BP1jtwJnK9FToH1m4EJKCPvEZSi0ovf4
         mvQB70hBggy/jL/2R9ObnIol5lW4kiA3q3fPkDq0yOBZUUq/77GSIjY5fybsIvlDqFHb
         tuazV433iWJcld51iKVDdQ3u+eFkpAqOMQxIZLXSApsMQiG11qHUSVuP8+Y5CzJ6u679
         tFQYKDWyCujhq8TVZElz9wfLRub4UdGxjWkVIDCa0xpghkag67WFQcgRDUAyneEfLCJc
         QPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fv8vyZIK5GEhBqzh5VZZkAmXzg5nvfAHE/JoOZfWhqE=;
        b=RiqM639Qe/fVWFmDsE7INVXRETLw96qe7gliNWgwNDE8iwJpOJAX+pSON9UQ/TrwLS
         T8MroVb/LUf+lhztu3UU2Jr3gnx+AVZe7C9yW3CkJAx5CbK+dNP5nMPsAJDxb2PpJ+rE
         DshdDzE6CVrAOZkkX/oEzhcTbMyIMs1ccyb00+7M1v6rMC/iisD92VGGR2NA30PdgBGH
         svgvR1DowByaZ+mJklZhJmwYEEykKbblDbcHHRoIRDZEmTgRKY+OpNOM32oBvFobS0nG
         mHKpjLlPRdy4VDkPJvfzZ+Dj9wydEnZdGBbaV/ki8Ym8VcnRqDJj8JiJwSeHNP4Ef7ID
         T3Ng==
X-Gm-Message-State: AGi0Puahg04prIFU2HaEJIgerHt249u/ukmDZtp1fJr8N9//L7gP1fhH
        qRc4iAOOzzOybRUk5DGbu2pnm6dRDlGrnRRx422s2kbuNaE=
X-Google-Smtp-Source: APiQypLzB+cpOAkBVvu3MAGQk06twrtj9M0uzTMhbYixU1z0TiBTZxdAzfP7afMie4Lbmk+9TnCWKWHTt9rin4DQ7hQ=
X-Received: by 2002:a05:6830:1e93:: with SMTP id n19mr4659418otr.153.1586322939607;
 Tue, 07 Apr 2020 22:15:39 -0700 (PDT)
MIME-Version: 1.0
From:   Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date:   Tue, 7 Apr 2020 22:15:29 -0700
Message-ID: <CAFCYAseETHROqsYf4Ot5OBx0X16c__C3EGio5rmtSiLV79nF1A@mail.gmail.com>
Subject: PCIe or mpt3sas loopback device to test PCIe side streaming?
To:     Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Greetings,

I'm looking for a method to test streaming write and read speeds to
and from the Broadcom (LSI) PCIe SAS controller without the use of any
physical block devices connected to the HBA. I want to test the
streaming performance of the PCIe side of the controller.

Does anyone know of any loopback within mpt3sas or similar function
that can be used with dd or fio to profile PCIe side streaming
performance?

Example:
dd if=/dev/zero of=/dev/somemptloopback bs=65536
dd of=/dev/null if=/dev/somemptloopback bs=65536

Many thanks,

--Jeff
