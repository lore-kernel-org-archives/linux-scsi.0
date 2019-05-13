From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/3] scsi: ufs: add error handlings of auto-hibern8
Date: Mon, 13 May 2019 22:36:23 +0800
Message-ID: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
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
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, pedrom.sousa@synopsys.com
Cc: marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, vivek.gautam@codeaurora.org, matthias.bgg@gmail.com, sayalil@codeaurora.org, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Currently auto-hibern8 is activated if host supports
auto-hibern8 capability. However no error handlings are existed thus
this feature is kind of risky.

If "Hibernate Enter" or "Hibernate Exit" fail happens
during auto-hibern8 flow, the corresponding interrupt
"UIC_HIBERNATE_ENTER" or "UIC_HIBERNATE_EXIT" shall be raised
according to UFS specification.

This patch adds auto-hibern8 error handlings:

- Monitor "Hibernate Enter" and "Hibernate Exit" interrupts after
  auto-hibern8 feature is activated.
- If fail happens, trigger error handlings just like "manual-hibernate"
  fail and use the same flow: Identify errors and schedule UFS error
  handler in ufshcd_check_errors(), and then do host reset and restore
  in UFS error handler.

Stanley Chu (3):
  scsi: ufs: do not overwrite auto-hibern8 timer
  scsi: ufs: add error handling of auto-hibern8
  scsi: ufs: use re-factored auto_hibern8 function

 drivers/scsi/ufs/ufshcd.c | 16 +++++++++++++++-
 drivers/scsi/ufs/ufshcd.h | 13 +++++++++++++
 drivers/scsi/ufs/ufshci.h |  3 +++
 3 files changed, 31 insertions(+), 1 deletion(-)

-- 
2.18.0
