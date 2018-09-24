From: Avri Altman <Avri.Altman@wdc.com>
Subject: Re: [PATCH V14 1/2] scsi: ufs: set the device reference clock setting
Date: Mon, 24 Sep 2018 07:58:04 +0000
Message-ID: <SN6PR04MB49250F1D665127DBA82137A3FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1537770516-28410-1-git-send-email-sayalil@codeaurora.org>,<1537770516-28410-2-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537770516-28410-2-git-send-email-sayalil@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>
Cc: "stummala@codeaurora.org" <stummala@codeaurora.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


>+static struct ufs_ref_clk ufs_ref_clk_freqs[] =3D {
>+       {19200000, REF_CLK_FREQ_19_2_MHZ},
>+       {26000000, REF_CLK_FREQ_26_MHZ},
>+       {38400000, REF_CLK_FREQ_38_4_MHZ},
>+       {52000000, REF_CLK_FREQ_52_MHZ},
>+       {0, REF_CLK_FREQ_INVAL},
>+};
>+
>+static inline enum ufs_ref_clk_freq
>+ufs_get_bref_clk_from_hz(u32 freq)
>+{
>+       int i =3D 0;
>+
>+       while (ufs_ref_clk_freqs[i].freq_hz !=3D freq) {
>+               if (!ufs_ref_clk_freqs[i].freq_hz)
>+                       return REF_CLK_FREQ_INVAL;
Is the if clause really needed?
you will return REF_CLK_FREQ_INVAL anyway

>+               i++;
You might overrun here if freq is not what you've expected

>+       }
>+
>+       return ufs_ref_clk_freqs[i].val;
>+}
