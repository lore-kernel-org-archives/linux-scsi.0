From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
Date: Sun, 4 Jan 2009 18:51:03 -0800
Message-ID: <20090104185103.06e2f531@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104093103.46167d23@infradead.org>
	<1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
	<20090104175830.7a7e279e@infradead.org>
	<1231123910.3967.34.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1231123910.3967.34.camel@yakui_zhao.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 05 Jan 2009 10:51:50 +0800
Zhao Yakui <yakui.zhao@intel.com> wrote:

> > because of the async_synchronize_cookie() call!
> After the async_synchronize_cookie is called, the register sequence
> will become strict. 
> But there exist multiple threads. It is possible that the function of
> acpi_bus_register_async is called on different threads. In such case
> the dependency can't be guaranteed. 

this is not correct.
when the async_synchronize_cookie() call returns, all previous
acpi_bus_register_async() calls have completed. So no older ones can be
running.

there also can be no newer ones, because newer ones will wait for the
current one to entirely complete before they will return from
acpi_bus_register_async()

so.. since all older ones are complete, and no new ones can happen..
the sequence is strictly followed.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
