From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Execute START_STOP_UNIT during init
Date: Fri, 28 Sep 2018 16:04:16 -0700
Message-ID: <20180928230416.GA30772@infradead.org>
References: <20180928230203.905-1-evgreen@chromium.org>
 <20180928230203.905-3-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180928230203.905-3-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adrian Hunter <adrian.hunter@intel.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Anderson <dianders@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 28, 2018 at 04:02:03PM -0700, Evan Green wrote:
> For UFS devices that are provisioned to have an initial power mode
> (bInitPowerMode) of "sleep", Linux will currently fail to enumerate
> the device. This is because the UFS specification says that the
> device must get a START_STOP_UNIT SCSI command to wake the unit
> up before other common initialization features like the device
> descriptor will be available to be read.

Yikes, this is just completely broken in terms of scsi compliance.

I think we should simply not support such devices.
