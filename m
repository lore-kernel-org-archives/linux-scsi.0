From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v1 0/8] phy: qcom-ufs: Enable regulators to be off in suspend
Date: Wed, 16 Jan 2019 14:32:13 -0800
Message-ID: <154767793304.169631.18064099850112277477@swboyd.mtv.corp.google.com>
References: <20190111230129.127037-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111230129.127037-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>
Cc: Can Guo <cang@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Evan Green <evgreen@chromium.org>, devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Grygorii Strashko <grygorii.strashko@ti.com>, linux-scsi@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Manu Gautam <mgautam@codeaurora.org>, David Brown <david.brown@linaro.org>, Mark Rutland <mark.rutland@arm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Quoting Evan Green (2019-01-11 15:01:21)
>=20
> Because the UFS PHY reset bit is now toggled in the PHY, rather
> than in ufs-qcom, this also percolated to all other PHYs using
> ufs-qcom, which from what I can see is just 8996.
>=20
> There are a couple of tradeoffs in this series that I'd welcome feedback
> on. First, it breaks compatibility with device trees that don't expose
> this new reset controller. Making this work with older device trees
> would be pretty ugly in the code, and given that the SDM845 UFS DT nodes
> aren't accepted upstream yet, the breakage seemed worth it. I'm not as
> sure about 8996.

It may take some minor surgery to the reset framework, but it should be
possible to register a reset lookup that can be used if nothing matches
in DT. Right now the reset code looks to only want to use DT if it's
there for the device requesting the reset. If there isn't a DT node for
the device it will look in the global lookup list. That could be changed
to fallback to the global lookup that uses device names (similar to clk
framework) when the DT lookup fails. Then it's just a matter of
registering the lookup for this reset with the handful of device names
that need the non-DT way of finding the reset.

Of course, that's another change and if breaking DT is simpler and
acceptable then I would say go for the path of least resistance and
don't try to modify reset framework for this.
