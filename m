From: Magnus Damm <magnus.damm@gmail.com>
Subject: BusLogic: MAX_DMA_ADDRESS
Date: Wed, 17 Nov 2004 16:26:26 +0100
Message-ID: <aec7e5c30411170726bcd6824@mail.gmail.com>
Reply-To: Magnus Damm <magnus.damm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.194]:10026 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262342AbUKQP01 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 10:26:27 -0500
Received: by wproxy.gmail.com with SMTP id 63so646169wri
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2004 07:26:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

The constant MAX_DMA_ADDRESS is used at two places in the code, and I
believe that ">=" comparsion should be used instead of ">".  Compare
with other drivers that use that constant.

Also, comments say something about hardware problems related to 16MiB
but the code checks against MAX_DMA_ADDRESS that could be set to
something else than 16MiB on non-i386 archs.

I think the most portable solution would be to remove the entire
"high_memory vs MAX_DMA_ADDRESS"-check and always enable
bounce-buffers for ISA-devices and BT-445S.

Who is running a 2.6-kernel on a machine with 16MiB or less RAM and
SCSI these days anyway...?

/ magnus
