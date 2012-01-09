From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 12/14] isci: ->lldd_ata_check_ready handler
Date: Mon, 9 Jan 2012 11:26:36 -0800
Message-ID: <CAA9_cmfv2xgLc6usdJcz0xdhmXeW3F3pYpiGaCogJSOELYARDA@mail.gmail.com>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
	<20120106010001.11464.91347.stgit@localhost6.localdomain6>
	<513F55D9529643AC8F6F4C5B4B9F4B9D@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <513F55D9529643AC8F6F4C5B4B9F4B9D@usish.com.cn>
Sender: linux-ide-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 8, 2012 at 5:57 PM, Jack Wang <jack_wang@usish.com> wrote:
>> +int isci_ata_check_ready(struct domain_device *dev)
>> +{
>> + =A0 =A0 struct isci_port *iport =3D dev->port->lldd_port;
>> + =A0 =A0 struct isci_host *ihost =3D dev_to_ihost(dev);
>> + =A0 =A0 struct isci_remote_device *idev;
>> + =A0 =A0 unsigned long flags;
>> + =A0 =A0 int rc =3D 0;
>> +
>> + =A0 =A0 spin_lock_irqsave(&ihost->scic_lock, flags);
>> + =A0 =A0 idev =3D isci_lookup_device(dev);
>> + =A0 =A0 spin_unlock_irqrestore(&ihost->scic_lock, flags);
>> +
>> + =A0 =A0 if (!idev)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 if (test_bit(IPORT_RESET_PENDING, &iport->state))
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 /* snapshot active phy mask */
>> + =A0 =A0 spin_lock_irqsave(&ihost->scic_lock, flags);
>> + =A0 =A0 rc =3D !!iport->active_phy_mask;
> [Jack Wang]
> Hi Dan,
>
> Could you explain why here you not directly use "
> rc =3D !!iport->active_phy_mask;

You are right, it can look at the field outside the lock... and since
we have already taken the lock to get a device reference we know we
have flushed any recent port events.

--
Dan
