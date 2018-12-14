From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/7] v4.19-stable randconfig fixes
Date: Fri, 14 Dec 2018 23:10:05 +0100
Message-ID: <20181214221023.3878670-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-aspeed@lists.ozlabs.org, Peter Zijlstra <peterz@infradead.org>, David Brown <david.brown@linaro.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-i2c@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Daniel Drake <dsd@laptop.org>, linux-scsi@vger.kernel.org, Jens Frederich <jfrederich@gmail.com>, openbmc@lists.ozlabs.org, Ingo Molnar <mingo@redhat.com>, Andy Gross <andy.gross@linaro.org>, devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>, dou_liyang@163.com, Rob Herring <robh+dt@kernel.org>, bp@alien8.de, Vincent Guittot <vincent.guittot@linaro.org>, linux-arm-kernel@lists.infradead.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Jeffery <andrew@aj.id.au>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

I did some randconfig testing on linux-4.19 arm/arm64/x86. So far I needed
27 patches, most of which are also still needed in mainline Linux. I
had submitted some before, and others were not submitted previously
for some reason. I'll try to get those fixed in mainline and then
make sure we get them into 4.19 as well.

This series for now contains four patches that did make it into mainline:

2e6ae11dd0d1 ("slimbus: ngd: mark PM functions as __maybe_unused")
33f49571d750 ("staging: olpc_dcon: add a missing dependency")
0eeec01488da ("scsi: raid_attrs: fix unused variable warning")
11d4afd4ff66 ("sched/pelt: Fix warning and clean up IRQ PELT config")

Feel free to either cherry-pick those from mainline or apply the
patch from this series, whichever works best for you.

The other three patches are for warnings in code that got removed in
mainline kernels:

3e9efc3299dd ("i2c: aspeed: Handle master/slave combined irq events properly")
972910948fb6 ("ARM: dts: qcom: Remove Arrow SD600 eval board")
effec874792f ("drm/msm/dpu: Remove dpu_dbg")

My feeling was that it's safer to just address the warning by fixing
the code correctly in each of these cases, but if you disagree,
applying the mainline change should work equally well, so decide
for yourself.

      Arnd

Arnd Bergmann (5):
  scsi: raid_attrs: fix unused variable warning
  slimbus: ngd: mark PM functions as __maybe_unused
  [stable-4.19] i2c: aspeed: fix build warning
  [stable-4.19] ARM: dts: qcom-apq8064-arrow-sd-600eval fix
    graph_endpoint warning
  [stable-4.19] drm/msm:  fix address space warning

Lubomir Rintel (1):
  staging: olpc_dcon: add a missing dependency

Vincent Guittot (1):
  sched/pelt: Fix warning and clean up IRQ PELT config

 arch/arm/boot/dts/qcom-apq8064-arrow-sd-600eval.dts | 5 +++++
 drivers/gpu/drm/msm/disp/dpu1/dpu_dbg.c             | 8 ++++----
 drivers/i2c/busses/i2c-aspeed.c                     | 4 +++-
 drivers/scsi/raid_class.c                           | 4 +---
 drivers/slimbus/qcom-ngd-ctrl.c                     | 6 ++----
 drivers/staging/olpc_dcon/Kconfig                   | 1 +
 init/Kconfig                                        | 5 +++++
 kernel/sched/core.c                                 | 7 +++----
 kernel/sched/fair.c                                 | 2 +-
 kernel/sched/pelt.c                                 | 2 +-
 kernel/sched/pelt.h                                 | 2 +-
 kernel/sched/sched.h                                | 5 ++---
 12 files changed, 29 insertions(+), 22 deletions(-)

Cc: Andrew Jeffery <andrew@aj.id.au>
Cc: Andy Gross <andy.gross@linaro.org>
Cc: bp@alien8.de
Cc: Daniel Drake <dsd@laptop.org>
Cc: David Brown <david.brown@linaro.org>
Cc: dou_liyang@163.com
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Jens Frederich <jfrederich@gmail.com>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: freedreno@lists.freedesktop.org
Cc: linux-i2c@vger.kernel.org
Cc: openbmc@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-aspeed@lists.ozlabs.org
Cc: linux-scsi@vger.kernel.org


-- 
2.20.0
