From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: associate bio write hint with WRITE CDB
Date: Fri, 04 Jan 2019 01:11:49 -0500
Message-ID: <yq15zv56jfe.fsf@oracle.com>
References: <20181226041504.66283-1-huangrandall@google.com>
        <20190103075133.GA5141@infradead.org>
        <20190103094755.GA96532@google.com>
        <e5bc96cd-1b48-3b7e-706f-4cbbd1a040a4@interlog.com>
        <6152b478ea77dacf57eef6f758ba795f756cd3da.camel@redhat.com>
        <yq1ef9t81fh.fsf@oracle.com> <20190104052251.GA205256@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190104052251.GA205256@google.com> (Randall Huang's message of
        "Fri, 4 Jan 2019 13:22:51 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Randall Huang <ihhuang@abmail.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, huangrandall@google.com
List-Id: linux-scsi@vger.kernel.org


Hi Randall,

> I am working on Android phone.

> The idea is to enable write hint for Turbo write UFS feature.  Turbo
> write feature in UFS 3.x is under discussion in JEDEC JC-64.  This
> patch is the under-lying framework for supporting this feature.

OK, but we can't blindly go setting GROUP NUMBER to a non-zero value.
That'll break a massive amount of devices which will fail READ/WRITE
commands with INVALID FIELD IN CDB.

So aside from requiring the device to report GROUP_SUP=1, we'll need
some sort of indication that this device supports the UFS Turbo Write
feature. If you are engaged with JEDEC on this, please tell them we'll
need a VPD page, a mode page, or something similar to use as trigger to
entertain enabling this feature.

-- 
Martin K. Petersen	Oracle Linux Engineering
