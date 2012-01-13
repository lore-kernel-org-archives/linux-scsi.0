From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Thu, 12 Jan 2012 17:51:27 -0800
Message-ID: <CABE8wwst8n10i_T00zOK1V72LgS9XOuaK78tTn=pM8AXoy9xvA@mail.gmail.com>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	<9095644D6BEB42D8ADE7EB255D282AE8@usish.com.cn>
	<CABE8wwvovD1n8U6DLxKYSGMAJ2RwLb=gxF=xCy98Bci_aEvNCQ@mail.gmail.com>
	<93016D61E9AE4462B084F3715705FDD6@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <93016D61E9AE4462B084F3715705FDD6@usish.com.cn>
Sender: linux-ide-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2012 at 5:37 PM, Jack Wang <jack_wang@usish.com> wrote:
>> For example libata will reset 3 times with increasing wait times (10=
s,
>> 10s, 35s). =C2=A0On the last attempt it will slow down the phy to gi=
ve the
>> ata device a better chance of connecting. =C2=A0libsas is just doing=
 3
>> 500ms tries at full speed and then giving up.
> [Jack Wang]
> Yes=EF=BC=8C in our internal test I expand the time to 10s, but I'm n=
ot sure this will be accepted by mainline kernel.

Do you happen to have logs of a passing and failing case, i.e. before
and after adding the 10s time delay change?

I think having libata do it's normal link recovery in this case would
solve both problems of giving enough time for ata device to come up,
and allowing the initial scan to find the device and let the initial
trip through ata eh manage link.  But it would be a pretty big change
from what libsas is doing currently for sata discovery.
