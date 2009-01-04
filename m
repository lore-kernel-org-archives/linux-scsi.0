From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 4 Jan 2009 09:24:30 -0800
Message-ID: <20090104092430.7ffd2c41@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch series is based on Linus' original reaction to some of the
fastboot patches which introduced an "asynchronous initcall level".
Linus did not like the initcall level approach much, and wanted a much
more finegrained kind of thing.

This patch series introduces asynchronous function calls.
The goal is still the same (boot faster), the method is entirely
different.

Asynchronous function calls allow drivers and subsystems to do
operations asynchronously, while providing a mechanism to serialize
the asynchronous operations at "externally visible" locations, such as
device number registrations. 

As such, this approach is NOT a "full parallel kernel init".
For one, it keeps device numbers stable. For another, it's very much
opt-in for any code using this.

Rather, it is more comparable to an out-of-order cpu, where computations
are done asynchronously, but are retired in program order.

This series first introduces the infrastructure in patch 1,
and then adds users of this infrastructure (scsi in patch2, libata in
patch 3 and acpi in patch 4).

To see this working, I uploaded a "before" and "after" kernel bootchart
for one of my testboxes at

http://www.fenrus.org/linux/before.svg
http://www.fenrus.org/linux/after.svg

As you can see with inkscape (or gimp or any other svg viewer), there
is still room for doing more things in parallel, but the 3 example usage
patches are a big win already.


One comment about the API:
Originally I had functionality in mind where the caller of
async_schedule() could get back the cookie value of the scheduled task.
However I had no users of this, so I removed the code to do this. If
someone finds a place where this is useful we can easily add this back.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
