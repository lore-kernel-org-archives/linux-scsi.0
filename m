From: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH 4/4] fastboot: make ACPI bus drivers probe asynchronous
Date: Mon, 05 Jan 2009 13:30:26 +0800
Message-ID: <1231133426.3967.53.camel@yakui_zhao.sh.intel.com>
References: <20090104092430.7ffd2c41@infradead.org>
	 <20090104093103.46167d23@infradead.org>
	 <1231120992.3967.18.camel@yakui_zhao.sh.intel.com>
	 <20090104175830.7a7e279e@infradead.org>
	 <1231123910.3967.34.camel@yakui_zhao.sh.intel.com>
	 <20090104185103.06e2f531@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090104185103.06e2f531@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-01-04 at 18:51 -0800, Arjan van de Ven wrote:
> On Mon, 05 Jan 2009 10:51:50 +0800
> Zhao Yakui <yakui.zhao@intel.com> wrote:
> 
> > > because of the async_synchronize_cookie() call!
> > After the async_synchronize_cookie is called, the register sequence
> > will become strict. 
> > But there exist multiple threads. It is possible that the function of
> > acpi_bus_register_async is called on different threads. In such case
> > the dependency can't be guaranteed. 
> 
> this is not correct.
> when the async_synchronize_cookie() call returns, all previous
> acpi_bus_register_async() calls have completed. So no older ones can be
> running.
Thanks for the detailed explanation. Understand it.
But I still have another question about the function of
async_synchronize_cookie. I don't know whether my understanding is
correct or not.
The function of async_synchronize_cookie is realized by comparing the
variable of lowest_in_progress with the cookie. Only when the
lowest_in_process is greater than or equal to the cookie value, it will
return. When async_schedule is called, a new cookie will be assigned,
which can also be used as the second argument of
async_synchronize_cookie.

The value of lowest_in_progress is updated after calling the callback
function (async_func_ptr). But the async_synchronize_cookie is called in
the callback function (acpi_bus_register_async). 
In such case it seems that there exists the dead lock. The value of
lowest_in_progress should be updated before finishing the async callback
function. But the value of lowest_in_progress is updated after calling
the async callback function.


> 
> there also can be no newer ones, because newer ones will wait for the
> current one to entirely complete before they will return from
> acpi_bus_register_async()
> 
> so.. since all older ones are complete, and no new ones can happen..
> the sequence is strictly followed.
> 

