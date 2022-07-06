Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67A5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 08:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiGFIua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 04:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGFIu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 04:50:28 -0400
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Jul 2022 01:50:27 PDT
Received: from mail.univention.de (mail.univention.de [82.198.197.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8442A22B20
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 01:50:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by solig.knut.univention.de (Postfix) with ESMTP id 5EDF11686702E;
        Wed,  6 Jul 2022 10:45:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=univention.de;
        s=202111; t=1657097111;
        bh=LCHxhz8WSop68Xxr/W18wkjCa1tHDMkZoYeUPldqKW0=;
        h=Date:To:From:Cc:Subject:From;
        b=d3yDPC/TcYO7v/7PhLijF6Y2UgZn6rG30LWUA7WYirjTigePPGvGZcJuPz2S9PeP+
         quJbud2nftaZTZN1qX3EesEcQOBtsNVrYigBjYvGKfEsq1L0MdZ3ulHjQqsCDtaABK
         iVCePIcniqQxVTTjE4YUU8Md8F2+p1x8h6ZUy3/SoxeB2qofXU0VX+P78ZvTiCGxtj
         CmcDZ2WbRpO7/0QNPzfaoG5ELBf96WTdPnQUSet6ryK0Dt+qphtvTOkxAtq2BCecIn
         CwpD9Sck6zHHRWsBIqqXMOIookSYJXS11AYa0gUaC/PXltYZOiF8oZbu9Rltw0pVgP
         LwhRsDRaC1kWg==
X-Virus-Scanned: by amavisd-new-2.10.1 (20141025) (Debian) at
        knut.univention.de
Received: from mail.univention.de ([127.0.0.1])
        by localhost (solig.knut.univention.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d1JzvZgRhX2h; Wed,  6 Jul 2022 10:45:09 +0200 (CEST)
Received: from [192.168.178.65] (p5b21e3b8.dip0.t-ipconnect.de [91.33.227.184])
        by solig.knut.univention.de (Postfix) with ESMTPSA id 8E04116867025;
        Wed,  6 Jul 2022 10:45:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=univention.de;
        s=202111; t=1657097109;
        bh=LCHxhz8WSop68Xxr/W18wkjCa1tHDMkZoYeUPldqKW0=;
        h=Date:To:From:Cc:Subject:From;
        b=HEZoYuD3chW6x8/QclvRSDdRawvLLzeIL1tXXru/mimZWTpguOpvO6pJatAsTmbKQ
         DqR0gzeebYAi0xZtZJWiOf6vhFNE+Ow9wXqvRFYixTKeQNevE+w/1ldrlPgRiscRZB
         c2XJb/RWrBvX3nSRv7G2ELqGYLn5E5sGvweOMqlLjdltFOnQKkaUM0i7FGUbm5AY78
         YH5BcTK9D+XhWoYHJ/7UmWgC3jhNtBaQPIlwD3nmszU6vrIOeouTihnt4Q6L5Yzqql
         Cu6WWVoHo9ZdivaDf/QR14sFbiqvjdQwH8FLUMsFg30XRM6+OY6lu1pI+kxhsys+EX
         pPheop5WIcPPw==
Message-ID: <86272920-fb2c-0dfe-c7d9-b744d1bb835e@univention.de>
Date:   Wed, 6 Jul 2022 10:45:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Don Brace <don.brace@microchip.com>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
From:   Philipp Hahn <hahn@univention.de>
Organization: Univention GmbH
Cc:     "helpdesk-intern@univention.de" <helpdesk-intern@univention.de>
Subject: smartpqi : resetting scsi due to cmd 0x88
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello together,

one of our Linux servers running Debian GNU/Linux 9 "Stretch" with the 
newer backport Linux kernel `4.19.235` regularly looses his disks:

> [Jul 6 09:19] smartpqi 0000:19:00.0: resetting scsi 15:1:0:0 due to cmd 0x88
> [ +10,204216] smartpqi 0000:19:00.0: scsi 15:1:0:0: waiting 10 seconds for LUN reset to complete (122 command(s) outstanding)

We also already observed this with Linux kernel version 4.9.xxx and 4.19.232

We have now switched to the latest driver and also updates the firmware, 
but this did not help:

> $ cat /sys/class/scsi_host/host15/firmware_version 
> 5.00
> $ cat /sys/class/scsi_host/host15/driver_version 
> 2.1.16-030
> $ uname -v
> #1 SMP Debian 4.19.235-1 (2022-03-17)

Is there anything we can do to solve this?

I have some basic Linux kernel knowledge myself, but I'm not a SCSI 
expert, but are willing to provide additional data if you need that.

Sincerely
Philipp

PS: I'm not subscribed to any of these mailing lists, so please cc: me. 
Thanks.
-- 
Philipp Hahn
Open Source Software Engineer

Univention GmbH
be open.
Mary-Somerville-Str. 1
D-28359 Bremen

📞 +49-421-22232-57
🖶 +49-421-22232-99

✉️ hahn@univention.de
🌐 https://www.univention.de/

Geschäftsführer: Peter H. Ganten, Stefan Gohmann
HRB 20755 Amtsgericht Bremen
Steuer-Nr.: 71-597-02876
