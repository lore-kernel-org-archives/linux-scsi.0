From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/14] Fix kmalloc overflow in LPFC driver at large core
 count
Date: Mon, 14 Sep 2015 09:35:53 +0200
Message-ID: <55F678D9.1030104@suse.de>
References: <55e4bd8c.8SprKlWFHxhnk4Ef%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbbINHfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:35:55 -0400
In-Reply-To: <55e4bd8c.8SprKlWFHxhnk4Ef%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> Note: original patch modified by me to resolve unused variable warnin=
g
>=20
> From: ian mitchell <imitchell@sgi.com>
>=20
> This patch allows the LPFC to start up without a fatal kernel bug bas=
ed
> on an exceeded KMALLOC_MAX_SIZE and a too large NR_CPU-based maskbits
> field. The bug was based on the number of CPU cores in a system.
> Using the get_cpu_mask() function declared in kernel/cpu.c allows the
> driver to load on the community kernel 4.2 RC1.
>=20
> Below is the kernel bug reproduced:
>=20
> 8<-------------------------------------------------------------------=
-
> 2199382.828437 (    0.005216)| lpfc 0003:02:00.0: enabling device (01=
40 -> 0142)
> 2199382.999272 (    0.170835)| ------------[ cut here ]------------
> 2199382.999337 (    0.000065)| WARNING: CPU: 84 PID: 404 at mm/slab_c=
ommon.c:653 kmalloc_slab+0x2f/0x89()
> 2199383.004534 (    0.005197)| Modules linked in: lpfc(+) usbcore(+) =
mptctl scsi_transport_fc sg lpc_ich i2c_i801 usb_common tpm_tis mfd_cor=
e tpm acpi_cpufreq button scsi_dh_alua scsi_dh_rdacusbcore: registered =
new device driver usb
> 2199383.020568 (    0.016034)|
> 2199383.020581 (    0.000013)|  scsi_dh_hp_sw scsi_dh_emc scsi_dh gru=
 thermal sata_nv processor piix fan thermal_sysehci_hcd: USB 2.0 'Enhan=
ced' Host Controller (EHCI) Driver
> 2199383.035288 (    0.014707)|
> 2199383.035306 (    0.000018)|  hwmon ata_piix
> 2199383.035336 (    0.000030)| CPU: 84 PID: 404 Comm: kworker/84:0 No=
t tainted 3.18.0-rc2-gat-00106-ga7ca10f-dirty #178
> 2199383.047077 (    0.011741)| ehci-pci: EHCI PCI platform driver
> 2199383.047134 (    0.000057)| Hardware name: SGI UV2000/ROMLEY, BIOS=
 SGI UV 2000/3000 series BIOS 01/15/2013
> 2199383.056245 (    0.009111)| Workqueue: events work_for_cpu_fn
> 2199383.066174 (    0.009929)|  000000000000028d ffff88eef827bbe8 fff=
fffff815a542f 000000000000028d
> 2199383.069545 (    0.003371)|  ffffffff810ea142 ffff88eef827bc28 fff=
fffff8104365c ffff88eefe4006c8
> 2199383.076214 (    0.006669)|  0000000000000000 00000000000080d0 000=
0000000000000 0000000000000004
> 2199383.079213 (    0.002999)| Call Trace:
> 2199383.084084 (    0.004871)|  [<ffffffff815a542f>] dump_stack+0x49/=
0x62
> 2199383.087283 (    0.003199)|  [<ffffffff810ea142>] ? kmalloc_slab+0=
x2f/0x89
> 2199383.091415 (    0.004132)|  [<ffffffff8104365c>] warn_slowpath_co=
mmon+0x77/0x92
> 2199383.095197 (    0.003782)|  [<ffffffff8104368c>] warn_slowpath_nu=
ll+0x15/0x17
> 2199383.103336 (    0.008139)|  [<ffffffff810ea142>] kmalloc_slab+0x2=
f/0x89
> 2199383.107082 (    0.003746)|  [<ffffffff8110fd9e>] __kmalloc+0x13/0=
x16a
> 2199383.112531 (    0.005449)|  [<ffffffffa01a8ed9>] lpfc_pci_probe_o=
ne_s4+0x105b/0x1644 [lpfc]
> 2199383.115316 (    0.002785)|  [<ffffffff81302b92>] ? pci_bus_read_c=
onfig_dword+0x75/0x87
> 2199383.123431 (    0.008115)|  [<ffffffffa01a951f>] lpfc_pci_probe_o=
ne+0x5d/0xcb5 [lpfc]
> 2199383.127364 (    0.003933)|  [<ffffffff81497119>] ? dbs_check_cpu+=
0x168/0x177
> 2199383.136438 (    0.009074)|  [<ffffffff81496fa5>] ? gov_queue_work=
+0xb4/0xc0
> 2199383.140407 (    0.003969)|  [<ffffffff8130b2a1>] local_pci_probe+=
0x1e/0x52
> 2199383.143105 (    0.002698)|  [<ffffffff81052c47>] work_for_cpu_fn+=
0x13/0x1b
> 2199383.147315 (    0.004210)|  [<ffffffff81054965>] process_one_work=
+0x222/0x35e
> 2199383.151379 (    0.004064)|  [<ffffffff81054e76>] worker_thread+0x=
3d5/0x46e
> 2199383.159402 (    0.008023)|  [<ffffffff81054aa1>] ? process_one_wo=
rk+0x35e/0x35e
> 2199383.163097 (    0.003695)|  [<ffffffff810599c6>] kthread+0xc8/0xd=
2
> 2199383.167476 (    0.004379)|  [<ffffffff810598fe>] ? kthread_freeza=
ble_should_stop+0x5b/0x5b
> 2199383.176434 (    0.008958)|  [<ffffffff815a8cac>] ret_from_fork+0x=
7c/0xb0
> 2199383.180086 (    0.003652)|  [<ffffffff810598fe>] ? kthread_freeza=
ble_should_stop+0x5b/0x5b
> 2199383.192333 (    0.012247)| ehci-pci 0000:00:1a.0: EHCI Host Contr=
oller
> -------------------------------------------------------------------->=
8
>=20
> The proposed solution was approved by James Smart at Emulex and teste=
d
> on a UV2 machine with 6144 cores. With the fix, the LPFC module loads
> with no unwanted effects on the system.
>=20
> Signed-off-by: Ian Mitchell <imitchell@sgi.com>
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Suggested-by: Robert Elliot <elliott@hp.com>
> Cc: James Smart <james.smart@avagotech.com>
> Cc: Dick Kennedy <dick.kennedy@avagotech.com>
> Cc: James E.J. Bottomley <JBottomley@odin.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 6 +-----
>  drivers/scsi/lpfc/lpfc_sli4.h | 1 -
>  2 files changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index eaf121a..bedbfe6 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8678,7 +8678,6 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, i=
nt vectors)
>  #ifdef CONFIG_X86
>  	struct cpuinfo_x86 *cpuinfo;
>  #endif
> -	struct cpumask *mask;
>  	uint8_t chann[LPFC_FCP_IO_CHAN_MAX+1];
> =20
>  	/* If there is no mapping, just return */
> @@ -8772,11 +8771,8 @@ found:
>  			first_cpu =3D cpu;
> =20
>  		/* Now affinitize to the selected CPU */
> -		mask =3D &cpup->maskbits;
> -		cpumask_clear(mask);
> -		cpumask_set_cpu(cpu, mask);
>  		i =3D irq_set_affinity_hint(phba->sli4_hba.msix_entries[idx].
> -					  vector, mask);
> +					  vector, get_cpu_mask(cpu));
> =20
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  				"3330 Set Affinity: CPU %d channel %d "
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_s=
li4.h
> index d1a5b05..1e916e1 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -454,7 +454,6 @@ struct lpfc_vector_map_info {
>  	uint16_t	core_id;
>  	uint16_t	irq;
>  	uint16_t	channel_id;
> -	struct cpumask	maskbits;
>  };
>  #define LPFC_VECTOR_MAP_EMPTY	0xffff
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
