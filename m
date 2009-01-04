From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 4 Jan 2009 10:16:57 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090104092430.7ffd2c41@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org



On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> 
> To see this working, I uploaded a "before" and "after" kernel bootchart
> for one of my testboxes at
> 
> http://www.fenrus.org/linux/before.svg
> http://www.fenrus.org/linux/after.svg

Ok, so why does the serial port init take so long? That's a quarter of a 
second for you, which is ridiculous.

I _think_ it's the irq auto-probing, but that's just a guess. The 8250 
driver does some historical crud, like

	probe_irq_off(probe_irq_on());

to get rid of any pending irq's, but that should be entirely pointless 
these days. I bet that line basically goes back to pre-history, before we 
made the auto-probing much stabler.

The irq auto-probing itself also has a few excessive delays, like waiting 
for 0.1 s just to wait for spurious interrupts to trigger. Doing the extra 
unnecessary probe makes that doubly expensive.

Does this patch make any difference to you? I'm not at all sure that it's 
the irq probing, but if it is, then this should make the serial probe go 
much faster.

		Linus

---
 drivers/serial/8250.c  |    1 -
 kernel/irq/autoprobe.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index daa0056..436372e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1259,7 +1259,6 @@ static void autoconfig_irq(struct uart_8250_port *up)
 	}
 
 	/* forget possible initially masked and pending IRQ */
-	probe_irq_off(probe_irq_on());
 	save_mcr = serial_inp(up, UART_MCR);
 	save_ier = serial_inp(up, UART_IER);
 	serial_outp(up, UART_MCR, UART_MCR_OUT1 | UART_MCR_OUT2);
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index cc0f732..e272784 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -60,7 +60,7 @@ unsigned long probe_irq_on(void)
 	}
 
 	/* Wait for longstanding interrupts to trigger. */
-	msleep(20);
+	msleep(10);
 
 	/*
 	 * enable any unassigned irqs
@@ -80,7 +80,7 @@ unsigned long probe_irq_on(void)
 	/*
 	 * Wait for spurious interrupts to trigger
 	 */
-	msleep(100);
+	msleep(10);
 
 	/*
 	 * Now filter out any obviously spurious interrupts
