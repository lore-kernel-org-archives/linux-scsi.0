From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: WARN_ON() in drivers/ata/libata-core.c:5211 ata_qc_issue
Date: Tue, 20 Apr 2010 16:16:16 +0200
Message-ID: <20100420141616.GP4586@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>, Ying Chu <jasonchu@marvell.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On mvsas, when I issue a SMART command (smartctl -a) while a dd
from /dev/sda to /dev/null is in progress, I hit the following
WARN_ON_ONCE in ata_qc_issue():

        if (ata_is_ncq(prot)) {
                WARN_ON_ONCE(link->sactive & (1 << qc->tag));

                if (!link->sactive)
                        ap->nr_active_links++;
                link->sactive |= 1 << qc->tag;
        } else {
                WARN_ON_ONCE(link->sactive);		<===============

                ap->nr_active_links++;
                link->active_tag = qc->tag;
        }

This is on 2.6.34-rc4 ish.
