From: "sayali" <sayalil@codeaurora.org>
Subject: RE: [PATCH V2 1/3] scsi: ufs: set the device reference clock setting
Date: Thu, 21 Jun 2018 14:22:04 +0530
Message-ID: <002401d4093d$256fdc90$704f95b0$@codeaurora.org>
References: <1528455990-24572-1-git-send-email-sayalil@codeaurora.org> <1528455990-24572-2-git-send-email-sayalil@codeaurora.org> <20180612192636.GA31725@rob-hp-laptop> <000101d403d3$87210d20$95632760$@codeaurora.org> <CAL_JsqLsdEGEjPo8yh5dGoGWTes41QxUiJ4NN0Q9qsgLBaTpjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqLsdEGEjPo8yh5dGoGWTes41QxUiJ4NN0Q9qsgLBaTpjw@mail.gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Rob Herring' <robh@kernel.org>
Cc: 'Subhash Jadavani' <subhashj@codeaurora.org>, 'Can Guo' <cang@codeaurora.org>, 'Vivek Gautam' <vivek.gautam@codeaurora.org>, 'Rajendra Nayak' <rnayak@codeaurora.org>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, asutoshd@codeaurora.org, 'Evan Green' <evgreen@chromium.org>, linux-scsi@vger.kernel.org, 'Mark Rutland' <mark.rutland@arm.com>, 'Mathieu Malaterre' <malat@debian.org>, "'open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS'" <devicetree@vger.kernel.org>, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Rob,

Please check my comment inline.

Thanks,
Sayali
-----Original Message-----
From: Rob Herring [mailto:robh@kernel.org]=20
Sent: Thursday, June 14, 2018 7:59 PM
To: sayali <sayalil@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>; Can Guo =
<cang@codeaurora.org>; Vivek Gautam <vivek.gautam@codeaurora.org>; =
Rajendra Nayak <rnayak@codeaurora.org>; Vinayak Holikatti =
<vinholikatti@gmail.com>; James E.J. Bottomley =
<jejb@linux.vnet.ibm.com>; Martin K. Petersen =
<martin.petersen@oracle.com>; asutoshd@codeaurora.org; Evan Green =
<evgreen@chromium.org>; linux-scsi@vger.kernel.org; Mark Rutland =
<mark.rutland@arm.com>; Mathieu Malaterre <malat@debian.org>; open =
list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS =
<devicetree@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] scsi: ufs: set the device reference clock =
setting

On Thu, Jun 14, 2018 at 5:33 AM, sayali <sayalil@codeaurora.org> wrote:
> Comment inline.
>
> Thanks,
> Sayali
> -----Original Message-----
> From: Rob Herring [mailto:robh@kernel.org]
> Sent: Wednesday, June 13, 2018 12:57 AM
> To: Sayali Lokhande <sayalil@codeaurora.org>
> Cc: subhashj@codeaurora.org; cang@codeaurora.org;=20
> vivek.gautam@codeaurora.org; rnayak@codeaurora.org;=20
> vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;=20
> martin.petersen@oracle.com; asutoshd@codeaurora.org;=20
> evgreen@chromium.org; linux-scsi@vger.kernel.org; Mark Rutland=20
> <mark.rutland@arm.com>; Mathieu Malaterre <malat@debian.org>; open=20
> list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS=20
> <devicetree@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH V2 1/3] scsi: ufs: set the device reference clock=20
> setting
>
> On Fri, Jun 08, 2018 at 04:36:28PM +0530, Sayali Lokhande wrote:
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>>
>> UFS host supplies the reference clock to UFS device and UFS device=20
>> specification allows host to provide one of the 4 frequencies (19.2=20
>> MHz,
>> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the=20
>> device reference clock frequency setting in the device based on what=20
>> frequency it is supplying to UFS device.
>>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  7 +++
>>  drivers/scsi/ufs/ufs.h                             |  9 ++++
>>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 24 ++++++++++
>>  drivers/scsi/ufs/ufshcd.c                          | 52
> ++++++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd.h                          |  1 +
>>  5 files changed, 93 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index c39dfef..4522434 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -41,6 +41,12 @@ Optional properties:
>>  -lanes-per-direction : number of lanes available per direction -=20
>> either 1
> or 2.
>>                         Note that it is assume same number of lanes=20
>> is
> used both
>>                         directions at once. If not specified, default =

>> is 2
> lanes per direction.
>> +- dev-ref-clk-freq   : Specify the device reference clock frequency, =
must
> be one of the following:
>> +                       0: 19.2 MHz
>> +                       1: 26 MHz
>> +                       2: 38.4 MHz
>> +                       3: 52 MHz
>> +                       Defaults to 26 MHz if not specified.
>
> I must have misunderstood your last response. I thought you could=20
> handle things without DT. If not, my question remains.
> [Sayali]: Ref clk frequency setting could vary from=20
> platfrom-to-platform(vendor specific). Hence we need to pass it via =
DT.
>         Currently in DT we do not set/mention any ref clk frequency=20
> parameter. Hence I have added one new DT entry to configure
>         required ref clk freq.

The clocks property contains "ref_clk". Is that not the same clock?
Why can't you read what that frequency is? Or you need to be able to =
change it to a specific frequency? These all look like typical =
oscillator frequencies, so I wouldn't expect you could change them =
(other than divide by 2 maybe).
[Sayali] : It is the same "ref_clk", but we need to be able to change it =
to a specific frequency as per requirement. Thus, we need new DT entry =
to specify/override reference clock frequency as per need.

Rob
