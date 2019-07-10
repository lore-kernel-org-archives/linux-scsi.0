From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 0/4] scsi: ufs: Provide fatal and auto-hibern8 error history
Date: Wed, 10 Jul 2019 21:38:17 +0800
Message-ID: <1562765901-18328-1-git-send-email-stanley.chu@mediatek.com>
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
Cc: sthumma@codeaurora.org, marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, peter.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, ygardi@codeaurora.org, matthias.bgg@gmail.com, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

This patchset provides more information of fatal errros and auto-hibern8 errors
to improve debugging by keeping their error history as completed as possible.

Thanks Avri so much for prompt reviewing patchset v1.

I would like to post new version to add one more patch "scsi: ufs: Add history of fatal events"
to provide history for "non-interrupt-based" errors and abnormal events as well.

Example of fatal errors,
- Link startup error
- Suspend error
- Resume error

Example of abnormal events,
- Task or request abort
- Device reset (now equals to Logical Unit Reset)
- Host reset

Changes in v3:
- Fix one missing place to track link startup error (Avri Altman)
- Add history of device reset events (Avri Altman)
- Add history of host reset events

Changes in v2:
- Add new patch "scsi: ufs: Add history of fatal events"

Stanley Chu (4):
  scsi: ufs: Change names related to error history
  scsi: ufs: Add fatal and auto-hibern8 error history
  scsi: ufs: Do not reset error history during host reset
  scsi: ufs: Add history of fatal events

 drivers/scsi/ufs/ufshcd.c | 94 ++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h | 42 ++++++++++++-----
 2 files changed, 90 insertions(+), 46 deletions(-)

-- 
2.18.0
