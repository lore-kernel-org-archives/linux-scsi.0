From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Date: Fri, 18 Jun 2010 13:26:32 -0700
Message-ID: <4C1BD678.1020405@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>	<20100618102330.29eccb5b@virtuousgeek.org>	<4C1BBF7D.8090904@kernel.org>	<20100618124956.40c869a0@virtuousgeek.org>	<4C1BD024.1030707@gmail.com> <20100618130538.0fc562ee@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100618130538.0fc562ee@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/18/2010 01:05 PM, Jesse Barnes wrote:
> On Fri, 18 Jun 2010 12:59:32 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>> just added this in(as a test), and the retval warning still shows up.
>> with the last post I just added a printk was that legit, and if so what
>> else might be added to it to make it complete and proper?
>
> What's the full warning?  Seems like printing the value should have
> been enough to shut up gcc...
>

this is the warning messg after applying yinghai's patch:

   CC      drivers/pci/setup-bus.o
drivers/pci/setup-bus.c: In function 
'pci_assign_unassigned_bridge_resources':
drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used


if I add a printk then gcc is content.. patch below, but not the best at 
creating printk's(the whole % thing messes me up) but here goes:

 From 48e15b87072c6b4286d943c55bfe2ae26d358795 Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Fri, 18 Jun 2010 13:23:27 -0700
Subject: [PATCH 4/4] bus.c_add_print
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/pci/setup-bus.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 66cb8f4..806b766 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -919,6 +919,7 @@ again:

  enable_all:
  	retval = pci_reenable_device(bridge);
+	printk(KERN_DEBUG "PCI%d: re-enabling device\n", retval);
  	pci_set_master(bridge);
  	pci_enable_bridges(parent);
  }
-- 
1.7.1.rc1.21.gf3bd6
