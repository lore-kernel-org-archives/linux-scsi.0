From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 03/14] libsas: prevent domain rediscovery competing
 with ata error handling
Date: Mon, 9 Jan 2012 12:03:17 -0800
Message-ID: <CAA9_cmc+-7=pctiBW_g25uJ7fNkrvCfrrLKSfLj0Vm_psoP01Q@mail.gmail.com>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
	<20120106005915.11464.83503.stgit@localhost6.localdomain6>
	<CAA9_cmfOBdi9E-9be-gmsyW1s+1MYRu0GS1LkFXpORvfJ2PtfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfOBdi9E-9be-gmsyW1s+1MYRu0GS1LkFXpORvfJ2PtfQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 9, 2012 at 11:14 AM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Thu, Jan 5, 2012 at 4:59 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
>> +void sas_unregister_dev(struct asd_sas_port *port, struct domain_de=
vice *dev)
>> +{
>> + =A0 =A0 =A0 if (!list_empty(&dev->disco_list_node)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* this rphy never saw sas_rphy_add */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&dev->disco_list_node);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_rphy_free(dev->rphy);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev->rphy =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_unregister_common_dev(port, dev);
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 if (dev->rphy) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_rphy_unlink(dev->rphy);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irq(&port->dev_list_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move_tail(&dev->dev_list_node, &p=
ort->destroy_list);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&port->dev_list_lock);
>
> This is too early to make the device appear removed from the domain.
> Will revise the patch to re-use disco_list_node to for
> port->destroy_list.

=2E..we also need to clear the parent sas_port's rphy reference to get
sas_port_delete to skip its call to sas_rphy_delete and leave it to
the DISCE_DESTRUCT event.
